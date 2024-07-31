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

import SwiftUI

struct UserView: View {
  @Environment(\.colorScheme) var colorScheme

  @Environment(\.scenePhase) var appScenePhase
  @EnvironmentObject var appModel: AppModel
  var body: some View {
    VStack {

      Spacer()
      if let me = appModel.me {
        AvatarBig(author: .constant(me.name))
        UserName(user: me)
      }

      VerticalSpacer(size: 30)
      ButtonComponentChatee(
        title: {
          Text("Log Out")
        },
        style: .normal,
        action: { onFinish in
          appModel.disconnect()
          ApplicationStateManager.global?.enter(LoginScreenDisplayState.self)
          onFinish()
        })

      if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        VerticalSpacer(size: 30)
        Text("Chatee v\(version)")
      }

      Spacer()

    }
  }
}
