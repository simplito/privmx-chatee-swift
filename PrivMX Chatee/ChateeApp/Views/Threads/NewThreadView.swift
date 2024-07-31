//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT Licence.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

 
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import SwiftUI

public struct UserEntryAdmin {
  public var id: UUID
  public var name: String
  public var publicKey: String
  public var isSelected: Bool
  public var isStaff: Bool

  public init(name: String, publicKey: String, isStaff: Bool) {
    self.id = UUID()
    self.name = name
    self.publicKey = publicKey
    self.isSelected = false
    self.isStaff = isStaff

  }

  public var userEntry: UserEntry {
    return UserEntry(name: name, publicKey: publicKey)
  }

}

struct NewThreadView: View {

  @Environment(\.colorScheme) var colorScheme

  @Binding var showCreateNewChat: Bool
  @Binding var newThreadName: String
  @Binding var users: [UserEntryAdmin]
  @EnvironmentObject var model: ThreadsModel
  @EnvironmentObject var appModel: AppModel

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

          if user.publicKey.wrappedValue != "" && user.wrappedValue.name != appModel.me!.name {
            HStack {
              Toggle(isOn: user.isSelected) {
                HStack {

                  UserName(user: user.wrappedValue)
                  Spacer()
                }
              }
            }
            .padding()
            .background(user.isSelected.wrappedValue ? Color.black.opacity(0.025) : Color.white)
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
        let newName = newThreadName.trimmingCharacters(in: .whitespacesAndNewlines)
        if newName == "" {
          onFinish()
          self.showCreateNewChat = false
          return
        }
        Task {
          let storeInfo = StoreThreadInfo(name: newName, threadCompanion: true)
          try? self.appModel.storesModel.newStore(
            JSONEncoder().encodeToString(storeInfo),
            for: self.users.filtered(by: { $0.isSelected }).map { $0.userEntry }.with(
              appModel.me!.userEntry),
            managedby: self.users.filtered(by: { $0.isSelected && $0.isStaff }).map { $0.userEntry }
              .with(appModel.me!.userEntry)
          ) { storeId in
            Task {
              if let storeInfo = try? await self.appModel.storesModel.getStoreInfo(for: storeId) {
                Task {
                  await appModel.storesModel.storeModel.setup(for: storeInfo)
                }

                let threadInfo = await ThreadInfo(name: newThreadName, storeId: storeId)
                let threadInfoJSON = JSONEncoder().encodeToString(threadInfo)
                try? await self.model.newThread(
                  threadInfoJSON,
                  for: self.users.filtered(by: { $0.isSelected }).map { $0.userEntry }.with(
                    appModel.me!.userEntry),
                  managedBy: self.users.filtered(by: { $0.isSelected && $0.isStaff }).map {
                    $0.userEntry
                  }.with(appModel.me!.userEntry)
                ) { threadId in
                  onFinish()
                  Task {
                    await hideCreateChat()

                  }
                }

              }

            }

          }
        }
      }
      .onAppear {
        appModel.apiConnect?.getAllUsers { users in

          self.users = users.map {
            UserEntryAdmin(name: $0.username, publicKey: $0.publicKey, isStaff: $0.isStaff)
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
    }.padding(20)
  }
}
