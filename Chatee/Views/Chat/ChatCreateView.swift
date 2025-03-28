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
import SwiftUI

struct ChatCreateView: View {

	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chateeDataController: ChateeDataController
	@EnvironmentObject var threadsModel: ThreadsModel
	@EnvironmentObject var storesModel: StoresModel

	@Binding var showCreateNewChat: Bool
	@State var newThreadName: String = ""
	@State var users: [UserEntryAdmin] = [UserEntryAdmin]()

	func setUsers(_ users: [UserEntryAdmin]) {
		self.users = users
	}

	func hideCreateChat() {
		self.showCreateNewChat = false
	}

	func showCreateChat() {
		self.showCreateNewChat = true
	}

	var body: some View {

		VStack(spacing: 10) {

			HStack {
				Text("New Chat").font(.title)
				Spacer()
			}
			VerticalSpacer(size: 10)

			HStack {
				Text("Chat Title").font(.headline)
				Spacer()
			}
			TextInput(content: $newThreadName)

			HStack {
				Text("Members").font(.headline)
				Spacer()
			}.frame(minWidth: 300)

			ScrollView {
				ForEach(self.$users, id: \.id) { user in

					if user.publicKey.wrappedValue != ""
						&& user.wrappedValue.name
							!= chateeDataController.currentUser!.name
					{
						HStack {
							Toggle(isOn: user.isSelected) {
								HStack {

									UserNameView(
										user: user
											.wrappedValue
											.userEntry)
									Spacer()
								}
							}
						}
						.padding()
						.background(
							user.isSelected.wrappedValue
								? Color.black.opacity(0.025)
								: Color.white
						)
						.border(colorScheme: colorScheme)
						.cornerRadius(10.0)
						.onTapGesture {
							user.isSelected.wrappedValue.toggle()
						}
					}
				}

			}.frame(minHeight: 300)

			ButtonComponentChatee(
				title: {
					Text("Save")
				},
				style: .wide
			) { onFinish in
				Task {
					defer{
						self.hideCreateChat()
					}
					let newThreadNameSimplified =
						newThreadName.trimmingCharacters(
							in: .whitespacesAndNewlines)
					if newThreadNameSimplified.isEmpty {
						onFinish()
						self.hideCreateChat()
						return
					}

					do {
						let newStore = try await self.storesModel.newStore(
							name: newThreadNameSimplified,
							for: self.users.filtered(by: {
								$0.isSelected
							}).map { $0.userEntry }.with(
								chateeDataController.currentUser),
							managedBy: self.users.filtered(by: {
								$0.isSelected && $0.isStaff
							}).map { $0.userEntry }.with(
								chateeDataController.currentUser))

						let _ = try await threadsModel.newThread(
							name: newThreadNameSimplified,
							connectedStoreId: newStore.storeId
								.toString(),
							for: self.users.filtered(by: {
								$0.isSelected
							}).map { $0.userEntry }.with(
								chateeDataController.currentUser),
							managedBy: self.users.filtered(by: {
								$0.isSelected && $0.isStaff
							}).map { $0.userEntry }.with(
								chateeDataController.currentUser))
					} catch (_) {

						NotificationCenter.toast(
							"Error while creating Chat")
						onFinish()
						self.hideCreateChat()
						return

					}
				}

			}

			HStack {
				ButtonComponentChateeText(
					title: {
						Text("Cancel")
					}, style: .normal
				) { onFinish in
					showCreateNewChat = false
					onFinish()
				}

			}

			Spacer()
		}
		.onAppear {

			Task {
				await self.setUsers(
					try self.chateeDataController.getAllUsers().toUserEntryAdmin()
				)
			}
		}
		.padding(20)
	}
}
