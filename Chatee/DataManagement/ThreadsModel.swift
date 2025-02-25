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

/// `ThreadsModel` is responsible for managing the list of threads within a specific context.
/// It handles data retrieval, thread creation, deletion, and the management of thread events.
@MainActor
open class ThreadsModel: Observable, ObservableObject {

	// MARK: - Properties

	 /// Reference to the PrivMX endpoint for connection.
	 weak var cdc: ChateeDataController?

	 /// The context ID associated with the current session.
	 var contextID: String?

	 /// Data model implementing `ListModelProtocol`, used for maintaining the list of threads in the context.
	 @Published public var model: ThreadListModel

	 /// Initializes a new instance of `ThreadsModel`.
	 public init() {
		 self.model = ThreadListModel()
	 }

	 /// The default limit for pagination.
	 var limit: Int64 = 10

	 // MARK: - Methods

	 /// Configures the `ThreadsModel` with an endpoint and context ID.
	 ///
	 /// > Warning: Requires a valid instance of `PrivMXEndpoint` to manage threads available in the provided context ID.
	 ///
	 /// - Parameters:
	 ///   - endpoint: An instance of `PrivMXEndpoint` for the connection.
	 ///   - contextID: The context ID managed at `PrivMXBridge`.
	 public func configure(
		cdc: ChateeDataController,
		contextID: String
	) {
		self.contextID = contextID
		self.cdc = cdc

		self.model.sortOrder = "desc"
		self.model.thesame = { $0.id == $1.id }
		self.model.compare = { $0.id < $1.id }
		self.model.loader = { skip, count, sortOrder, rc in
			Task {
				let thrsResponse = try cdc.endpointController.currentEndpoint?.threadApi?
					.listThreads(
						from: self.contextID!,  // threads in context
						basedOn: privmx.endpoint.core.PagingQuery(
							skip: skip,  // number of skipped elements
							limit: self.limit,  // upper limit of response size
							sortOrder: self.model.sortOrder.pmxSortOrder  // sort order
						)
					)
				let thrs =
					thrsResponse?.readItems.map { $0 }
					?? [privmx.endpoint.thread.Thread]()
				let available = Int64(thrsResponse?.totalAvailable ?? 0)
				rc(available, thrs)
			}

		}
	}

	/// Sets up the `ThreadsModel` by clearing the current data model and loading the first set of data.
    /// Registers listeners for thread-related events.
    public func setup() {
   
		self.model.clear()
		self.model.loadNext()

		_ = try? cdc?.endpointController.currentEndpoint?.registerCallback(
			for: privmx.endpoint.thread.ThreadCreatedEvent.self,
			from: EventChannel.thread, identified: ""
		) {
			data in
			
			if let newThreadData = data as? privmx.endpoint.thread.Thread {
				Task {
					await self.add(newData: newThreadData)
				}
			}
		}
		_ = try? cdc?.endpointController.currentEndpoint?.registerCallback(
			for: privmx.endpoint.thread.ThreadUpdatedEvent.self,
			from: EventChannel.thread, identified: ""
		) {
			data in
			if let data = data as? privmx.endpoint.thread.Thread {

				Task {
					await self.updateModelWith(newData: data)
				}
			}
		}
		_ = try? cdc?.endpointController.currentEndpoint?.registerCallback(
			for: privmx.endpoint.thread.ThreadStatsChangedEvent.self,
			from: EventChannel.thread, identified: ""
		) {
			data in
			
			if let data = data as? privmx.endpoint.thread.ThreadStatsEventData {
				Task {
					//await MainActor.run {
						if let thread = try? await self.getThread(
							for: data.threadId.toString())
						{
							Task {
								await self.updateModelWith(
									newData: thread)
							}
						}
					//}
				}

			}

		}
	}

	/// Adds a new thread to the model.
    ///
    /// - Parameter Thread: The thread to be added.
    func add(newData Thread: privmx.endpoint.thread.Thread) {
		Task {
			self.model.add(element: Thread)
		}
	}

	/// Updates the model with new thread data.
    ///
    /// - Parameter Thread: The thread data to update the model with.
    func updateModelWith(newData Thread: privmx.endpoint.thread.Thread) {
		Task {
			self.model.update(Thread)
		}
	}

	/// Retrieves a `Thread` object for a given thread ID.
    ///
    /// - Parameter threadId: The thread identifier obtained from PrivMX Bridge.
    /// - Throws: An error if the thread could not be retrieved.
    /// - Returns: The `Thread` object for the specified thread ID.
    public func getThread(for threadId: String) throws -> privmx.endpoint.thread.Thread {
		if let thread = try cdc?.endpointController.currentEndpoint?.threadApi?.getThread(threadId) {
			return thread
		} else {
			var err = privmx.InternalError()
			err.name = "Get Thread Error"
			err.message = std.string("Exception while getting Thread for \(threadId)")
			throw PrivMXEndpointError.otherFailure(err)
		}
	}

	/// Creates a new thread with the specified name, connected store ID, and users.
    ///
    /// - Parameters:
    ///   - name: The name of the new thread.
    ///   - connectedStoreId: The ID of the store connected to the thread.
    ///   - users: A list of `UserEntry` objects representing the users in the thread.
    ///   - managers: A list of `UserEntry` objects representing the managers of the thread.
    /// - Throws: An error if the thread could not be created.
    /// - Returns: The newly created `Thread` object.
   public func newThread(
		name: String,
		connectedStoreId: String,
		for users: [UserEntry],
		managedBy managers: [UserEntry]
	) async throws -> privmx.endpoint.thread.Thread {
		let threadPrivateMeta = ThreadPrivateMeta(name: name, storeId: connectedStoreId)
		let threadPrivateMetaEncoded = try JSONEncoder().encode(threadPrivateMeta)
		guard let contextID = self.contextID else {
			var err = privmx.InternalError()
			err.name = "New Thread Error"
			err.message = "ContextId is not set"
			throw PrivMXEndpointError.otherFailure(err)
		}
		guard
			let newThreadId = try cdc?.endpointController.currentEndpoint?.threadApi?.createThread(
				in: contextID, for: users.toUserWithPubKey(),
				managedBy: managers.toUserWithPubKey(),
				withPublicMeta: Data(),
				withPrivateMeta: threadPrivateMetaEncoded,
				withPolicies: nil
			)
		else {
			var err = privmx.InternalError()
			err.name = "New Thread Error"
			err.message = "createThread failed"
			throw PrivMXEndpointError.otherFailure(err) }

		return try getThread(for: newThreadId)

	}

	/// Removes an existing thread from the context and deletes the associated store if present.
    ///
    /// - Parameter threadId: The identifier of the thread to remove.
    /// - Throws: An error if the thread or store could not be removed.
    public func remove(thread threadId: String) async throws {
		let threadToRemove = try getThread(for: threadId)
		if let storeToRemove = threadToRemove.associatedStoreId {
			try cdc?.endpointController.currentEndpoint?.storeApi?.deleteStore(storeToRemove)
		}
		try cdc?.endpointController.currentEndpoint?.threadApi?.deleteThread(threadId)
		self.model.remove(threadToRemove)
	}
}
