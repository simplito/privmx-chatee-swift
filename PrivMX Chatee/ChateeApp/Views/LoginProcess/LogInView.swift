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

import AuthenticationServices
import Foundation
import SwiftUI

struct LogInView: View {

  @EnvironmentObject var appModel: AppModel

  var body: some View {

    VStack(spacing: 10) {
      Spacer()
      ChateeIcon()
      HStack {
        Text("Log in").font(.title)
        Spacer()
      }
      VerticalSpacer(size: 10)

      HStack {
        Text("Username").font(.headline)
        Spacer()
      }
      TextInput(content: $appModel.login)
      HStack {
        Text("Pasword").font(.headline)
        Spacer()
      }
      PasswordInput(content: $appModel.password)

      ButtonComponentChatee(
        title: {
          Text("Log In")
        },
        style: .wide
      ) { onFinish in
        ApplicationStateManager.global?.enter(
          GeneratingPrivateKeyState.self)
        onFinish()
      }

      HStack {
        Text("No Account?")

        ButtonComponentChateeText(
          title: {
            Text("Create new")
          },
          style: .normal
        ) { onFinish in
          ApplicationStateManager.global?.enter(
            CreatingAccountState.self)
          onFinish()
        }

      }
      VerticalSpacer(size: 20)
      HStack {

        Text(appModel.domain)
        ButtonComponentChateeText(
          title: {
            Text("Change domain")
          }, style: .normal
        ) { onFinish in
          ApplicationStateManager.global?.enter(
            DomainScreenDisplayState.self)
          onFinish()
        }

      }

      Spacer()

    }.padding(40).interactiveDismissDisabled(true)

  }
}
