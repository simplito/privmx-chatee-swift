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

import Foundation
import SwiftUI

struct LeftPanel: View {
  @EnvironmentObject var appModel: AppModel
  @Binding var showUserDetails: Bool

  var body: some View {
    NavigationSplitView {
      HStack {
        Text("Chats").font(.title)
        Spacer()
        if let user = self.appModel.me {
          UserName(user: user)
          Avatar(author: .constant(user.name))
        }
      }.padding()
        .onTapGesture {
          self.showUserDetails = true
        }
        .navigationDestination(isPresented: $showUserDetails) {
          UserView()
            .environmentObject(appModel)
        }
      VStack {
        ThreadList().environmentObject(self.appModel.threadsModel).environmentObject(self.appModel)
      }
    } detail: {
      Text("Select chat in the left palnel to see messages here.")
    }

  }
}
