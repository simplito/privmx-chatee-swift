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

struct ChatView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chateeDataController: ChateeDataController

	@Binding var selectedThread: privmx.endpoint.thread.Thread?
	@ObservedObject var threadModel = ThreadModel()
	@ObservedObject var storeModel = StoreModel()

	@State var showFiles = false

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				VStack(spacing: 0) {

					HStack {
						Image(systemName: "text.bubble").frame(width: 20)

						Text(selectedThread?.titleDecoded ?? "").font(
							.title2)
						Spacer()

						HStack(spacing: 0) {

							ToggleComponentChatee(
								isActive: $showFiles,
								title: {
									Icon(
										size: 25,
										icon: "messages",
										color: showFiles
											? Color
												.buttonBackground(
													colorScheme
												)
											: Color
												.buttonFront(
													colorScheme
												))
								}, style: .normal
							) { onFinish in
								showFiles.toggle()
								onFinish()
							}
							ToggleComponentChatee(
								isActive: !$showFiles,
								title: {
									Icon(
										size: 25,
										icon: "files",
										color: !showFiles
											? Color
												.buttonBackground(
													colorScheme
												)
											: Color
												.buttonFront(
													colorScheme
												))

								}, style: .normal
							) { onFinish in
								showFiles.toggle()
								onFinish()
							}
						}.background { Color.buttonFront(colorScheme) }
							.cornerRadius(5)
						ButtonComponentChatee(
							title: {
								Icon(
									size: 25, icon: "paperclip",
									color: Color.buttonFront(
										colorScheme))

							}, style: .normal
						) { onFinish in

							MultiplatformFileSelector(
								{ name, fileHandle, size, mimetype in
									guard
										let cu = self
											.chateeDataController
											.currentUser
									else { return }
									Task {
										guard
											let
												threadId =
												self
												.selectedThread?
												.threadId
												.toString()
										else {
											onFinish()
											return
										}
										guard
											let
												storeId =
												self
												.storeModel
												.storeInfo?
												.storeId
												.toString()
										else {
											onFinish()
											return
										}
										guard
											let
												newFileId =
												try?
												await
												storeModel
												.newFile(
													in: storeId,
													for: threadId,
													name: name,
													fileHandle: fileHandle,
													withSize:size,
													mimetype: mimetype
												)
										else {
											onFinish()
											return
										}

										threadModel.send(
											message:
												MessageFileUpload(
													fileId:
														newFileId,
													fileName:
														name
												),
											from: cu)
									}

								},
								onCancel: {
									onFinish()
								}
							)
							.selectFile()

						}

					}
					.padding()

					Rectangle().foregroundColor(.black.opacity(0.1)).frame(
						height: 1)
					if showFiles {

						FolderView()
							.environmentObject(storeModel)

					} else {
						MessagesView(selectedThread: $selectedThread)
							.environmentObject(storeModel)
							.environmentObject(threadModel)
							.environmentObject(chateeDataController)
					}
				}
				.mainBorder(colorScheme: colorScheme)
			}
		}
		.onAppear {
			self.setupThreadAndStore()
		}.onChange(of: selectedThread) {
			self.setupThreadAndStore()
		}

	}

	func setupThreadAndStore() {
		threadModel.configure(
			endpoint: self.chateeDataController.endpointController.currentEndpoint!
		)
		storeModel.configure(
			endpoint: self.chateeDataController.endpointController.currentEndpoint!
		)
		if let selectedThread = selectedThread {
			threadModel.setup(thread: selectedThread)
		}
		if let storeId = selectedThread?.associatedStoreId {
			storeModel.setup(store: storeId)
		}
	}
}
