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

struct MainAppView: View {

	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chateeDataController: ChateeDataController
	@ObservedObject var threadsModel = ThreadsModel()
	@ObservedObject var storesModel = StoresModel()

	@State var selectedThread: privmx.endpoint.thread.Thread?
	@State var showCreateNewChat = false
	@State var filter = ""

	var body: some View {
		VStack {
			NavigationSplitView(
				sidebar: {
					VStack {
						if let currentUser = chateeDataController
							.currentUser
						{
							HStack {
								UserNameView(user: currentUser)
							}
						}
						HStack {

							TextInput(content: $filter)
							ButtonComponentChateeSmall(
								title: {

									Icon(
										size: 25,
										icon: "plus",
										color:
											Color
											.buttonFront(
												colorScheme
											))

								}, style: .normal
							) { _ in
								showCreateNewChat = true
							}

						}

					}.padding()

					ListComponent<
						privmx.endpoint.thread.Thread, String, HStack,
						VStack
					>(
						.normal,
						withArrow: .none,
						groupingBy: { String($0.threadId) },
						sortedBy: { $0.createDate > $1.createDate },
						filteredBy: {
							$0.titleDecoded.contains(
								string: self.filter)
						},
						header: {
							t, firstEntry in
							HStack {}
						}
					) { t in
						VStack {
							ThreadRow(
								thread: t,
								selectedThread: $selectedThread
							)
							.contextMenu {
								if t.hasModifyPermission(
									chateeDataController
										.currentUser)
								{
									Button {
										Task {
											do {
												try
													await
													threadsModel
													.remove(
														thread:
															t
															.threadId
															.toString()
													)
											} catch ( _ )
											{
												NotificationCenter
													.toast(
														"Cannot delete this thread"
													)
											}
										}

									} label: {
										HStack {
											Icon(
												size:
													15,
												icon:
													"trash",
												color:
													Color
													.buttonFront(
														colorScheme
													)
											)
											Text(
												"Delete"
											)
										}
									}
								} else {
									Text(
										"No actions available for this thread."
									)
								}

							}
						}
					}
					.environmentObject(
						self.threadsModel.model
							as ListModel<privmx.endpoint.thread.Thread>)
				},
				detail: {
					if selectedThread == nil {
						VStack {
							Icon(
								size: 45,
								icon: "messages",
								color:
									Color
									.buttonBackground(
										colorScheme
									))
							VerticalSpacer(size: 30)
							Text("Chat not selected").font(.title)
							Text("Select chat from list or create new")
							VerticalSpacer(size: 30)
							ButtonComponentChateeSmall(
								title: {
									HStack {

										Icon(
											size: 25,
											icon:
												"plus",
											color:
												Color
												.buttonFront(
													colorScheme
												))
										Text(
											"Create new Chat"
										)
									}

								}, style: .normal
							) { _ in
								showCreateNewChat = true
							}
						}

					} else {
						ChatView(selectedThread: $selectedThread)
					}
				})
		 
		}
		.mainBorder(colorScheme: colorScheme)
		.sheet(isPresented: $showCreateNewChat) {

			ChatCreateView(
				showCreateNewChat: $showCreateNewChat
			).environmentObject(threadsModel)
				.environmentObject(storesModel)
		}
		.onAppear {

			if self.chateeDataController.connectionState == .connected, let contextId = chateeDataController.contextId, let currentEndpoint = self.chateeDataController
				.endpointController
					  .currentEndpoint {
				threadsModel.configure(
					cdc: self.chateeDataController,
					contextID: contextId
				)
				threadsModel.setup()
				storesModel.configure(
					endpoint: currentEndpoint,
					contextID: contextId
				)
				storesModel.setup()
			}
		}

	}
}
