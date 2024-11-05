//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative
import SwiftUI

/// `ThreadModel` manages the interaction with a thread, including listing messages, sending new messages,
/// and handling message-related events.
@MainActor
open class ThreadModel: Observable, ObservableObject {

	// MARK: - Properties

	/// Reference to the PrivMX endpoint for connection.
	var endpoint: PrivMXEndpoint?

	/// The currently configured thread.
	@Published public var thread: privmx.endpoint.thread.Thread?

	/// Data model implementing `ListModelProtocol`, used for maintaining the list of messages in the thread.
	@Published public var model: ThreadMessageListModel

	/// Initializes a new instance of `ThreadModel`.
	init() {
		model = ThreadMessageListModel()
	}

	// MARK: - Methods

	/// Configures the `ThreadModel` with an endpoint and sets up the message loader.
	///
	/// - Parameter endpoint: An instance of `PrivMXEndpoint` to be used for connection.
	public func configure(
		endpoint: PrivMXEndpoint
	) {

		self.endpoint = endpoint
		self.model.sortOrder = "desc"
		self.model.thesame = { $0.id == $1.id }
		self.model.compare = { $0.info.createDate > $1.info.createDate }

		self.model.loader = { skip, count, sortOrder, rc in

			var messages = [privmx.endpoint.thread.Message]()
			var available: Int64 = 0
			do {
				if let threadID = self.thread?.id {
					let msglist = try self.endpoint?.threadApi?
						.listMessages(
							from: threadID,
							basedOn: privmx.endpoint.core.PagingQuery(
								skip: skip, limit: 10,
								sortOrder: "desc".pmxSortOrder))
					messages =
						msglist?.readItems.map { $0 }
						?? [privmx.endpoint.thread.Message]()
					available = msglist?.totalAvailable ?? 0

					rc(available, messages)
				}
			} catch {
				NotificationCenter.toast("Unexpected error when getting messages")
			}

		}

	}

	/// Sets up the `ThreadModel` for a specific thread, clearing the current data model and loading the first set of messages.
    ///
    /// - Parameter thread: The thread to configure.
    public func setup(thread: privmx.endpoint.thread.Thread) {

		//self.endpoint?.clearAllCallbacks()

		self.thread = thread
		self.model.clear()
		self.model.loadNext()

		_ = try? self.endpoint?.registerCallback(
			for: privmx.endpoint.thread.ThreadNewMessageEvent.self,
			from: EventChannel.threadMessages(threadID: thread.id), identified: ""
		) {
			data in
			if let data = data as? privmx.endpoint.thread.Message {
				Task {
					if await data.info.threadId == self.thread?.threadId {
						await self.add(newData: data)
					}
				}
			}
		}
	}

	/// Adds a new message to the thread model.
    ///
    /// - Parameter threadMessage: The message to add.
    func add(newData threadMessage: privmx.endpoint.thread.Message) {
		Task {
			model.add(element: threadMessage)
		}
	}

	/// Sends a new message with codable content.
	///
	/// - Parameters:
	///   - content: The message content to send.
	///   - user: The user sending the message.
   public func send(message content: Codable, from user: UserEntry) {
		if let data = try? JSONEncoder().encode(content) {
			self.send(data: data, from: user)
		}
	}

	/// Sends a new message in the currently configured thread.
    ///
    /// - Parameters:
    ///   - content: The message content as `Data`.
    ///   - user: The user sending the message.
    public func send(data content: Data, from user: UserEntry) {

		Task {
			do {
				if let thread = self.thread {
					_ = try self.endpoint?.threadApi?.sendMessage(
						in: thread.id, withPublicMeta: Data(),
						withPrivateMeta: Data(), containing: content)

				}
			} catch PrivMXEndpointError.failedCreatingMessage(_) {
				NotificationCenter.toast("Failed creating Message")

			} catch _ {
				NotificationCenter.toast("Unexpected error when creating message")

			}
			self.model.loadNew()

		}
	}

	/// Deletes a message from the thread.
    ///
    /// - Parameter message: The message to be deleted.
    public func deleteMessage(message: privmx.endpoint.thread.Message) {
		Task {

			_ = try? self.endpoint?.threadApi?.deleteMessage(message.id)

			self.model.remove(message)
		}
	}

}
