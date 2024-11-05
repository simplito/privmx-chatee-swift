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


import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative
import SwiftUI

struct MessagesView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chateeDataController: ChateeDataController
	@EnvironmentObject var threadModel: ThreadModel
	@EnvironmentObject var storeModel: StoreModel

	@Binding var selectedThread: privmx.endpoint.thread.Thread?

	@State var textToSend = ""

	@MainActor
	func setTextToSend(_ text: String) {
		self.textToSend = text
	}

	var body: some View {
		ListComponent<privmx.endpoint.thread.Message, String, HStack, ZStack>(
			.reversed,
			withArrow: .onOther,
			groupingBy: {
				let author = String($0.info.author)
				let date = $0.info.createDate.threeMinutesAgo()
				return "\(author) - \(date) - \($0.info.threadId)"
			},
			sortedBy: { $0.info.createDate > $1.info.createDate },
			filteredBy: { element in true },
			header: {
				name, firstEntry in
				HStack {
					AuthorContentRow(
						author: firstEntry!.info.author.toString(),
						date: firstEntry!.info.createDate
							.convertInt64ToDate() ?? "?"
					).environmentObject(threadModel)

				}
			}
		) { message in

			ZStack {
				HStack {
					if let filemessage = message.data.fileMessage {
						SimpleFileRow(
							fileId: filemessage.fileId,
							fileName: filemessage.fileName
						)
						.environmentObject(storeModel)
					}
				}
				VStack {
					if let content = message.data.contentMessage {
						SimpleContentRow(content: content.content)
					}
					if let filemessage = message.data.fileMessage {
						SimpleContentRow(content: filemessage.fileName)
					}
				}
				.contextMenu {
					if let name = chateeDataController.currentUser?.name,
						message.info.author.toString() == name
							|| chateeDataController.currentUser?.isStaff
								?? false
					{
						Button {
							self.threadModel.deleteMessage(
								message: message)
						} label: {
							HStack {
								Icon(
									size: 15, icon: "trash",
									color: Color.buttonFront(
										colorScheme))
								Text("Delete")
							}
						}
					} else {
						Text("No actions available for this message.")
					}

				}
			}
		}.environmentObject(
			self.threadModel.model as ListModel<privmx.endpoint.thread.Message>)
		HStack {
			PlainTextInput<HStack>(content: self.$textToSend) {
				HStack {
					Text(
						"New message in \"\(self.selectedThread?.titleDecoded ?? "")\""
					)

				}
			}
			.focusable(false)

			.padding(10)
			HStack(spacing: 0) {
				ButtonComponentChatee(
					title: {
						Icon(
							size: 25, icon: "send",
							color: Color.buttonFront(colorScheme))

					}, style: .normal
				) { onFinish in
					Task {
						if self.textToSend != "" {
							let messageContent = MessageContent(
								text: self.textToSend)
							 
							if let currentUser = chateeDataController
								.currentUser
							{
								threadModel.send(
									message: messageContent,
									from: currentUser)
								self.setTextToSend("")
							}
						}
					}
					onFinish()
				}
			}.padding([.trailing], 7)

		}.padding(3.0)
			.border(colorScheme: colorScheme)
			.padding(10)
	}
}
