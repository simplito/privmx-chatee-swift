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
import PrivMXEndpointSwiftNative
import SwiftUI

struct ThreadList: View {
  @Environment(\.colorScheme) var colorScheme

  @EnvironmentObject var threadsModel: ThreadsModel
  @EnvironmentObject var appModel: AppModel
  @State var showCreateNewChat = false
  @State var newThreadName = ""
  @State var filter = ""
  @State var users = [UserEntryAdmin]()
  @State var selectedId: String = ""
  var body: some View {
    VStack {
      VStack {

        HStack {

          TextInput(content: $filter)
          ButtonComponentChateeSmall(
            title: {

              Icon(size: 25, icon: "plus", color: Color.buttonFront(colorScheme))

            }, style: .normal
          ) {
            showCreateNewChat = true
          }

        }

      }.padding()

      ListComponent<privmx.endpoint.thread.ThreadInfo, String, HStack, VStack>(
        .normal,
        withArrow: .none,
        groupingBy: { String($0.threadId) },
        sortedBy: { $0.createDate > $1.createDate },
        filteredBy: { $0.data.titleDecoded.contains(string: self.filter) },
        header: {
          t, firstEntry in
          HStack {}
        }
      ) { t in
        VStack {
          ThreadRow(thread: t, selected: $selectedId).environmentObject(threadsModel)
            .contextMenu {
              if t.creator.toString() == appModel.me!.name || appModel.me!.isStaff {
                Button {

                  self.appModel.threadsModel.remove(thread: t.threadId.toString()) { r in

                  }

                } label: {
                  HStack {
                    Icon(size: 15, icon: "trash", color: Color.buttonFront(colorScheme))
                    Text("Delete")
                  }
                }
              } else {
                Text("No actions available for this thread.")
              }

            }
        }
      }.environmentObject(self.threadsModel.model as ListModel<privmx.endpoint.thread.ThreadInfo>)

      Spacer()
    }
    .mainBorder(colorScheme: colorScheme)

    .sheet(isPresented: $showCreateNewChat) {
      NewThreadView(
        showCreateNewChat: $showCreateNewChat, newThreadName: $newThreadName, users: $users
      ).environmentObject(threadsModel)
    }

  }

}
