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

struct CreateAccountView: View {
  @State var username: String = ""
  @State var password: String = ""
  @State var invitationtoken: String = ""
  @State var password_rep: String = ""

  @EnvironmentObject var appModel: AppModel

  var body: some View {

    VStack(spacing: 10) {
      Spacer()
      ChateeIcon()
      HStack {
        Text("New Account").font(.title)
        Spacer()
      }
      VerticalSpacer(size: 10)

      HStack {
        Text("Invitation Key").font(.headline)
        Spacer()
      }
      TextInputWithPlaceholder(text: "xxxx-xxxx-xxxx", content: $invitationtoken)
      HStack {
        Text("Username").font(.headline)
        Spacer()
      }
      TextInput(content: $username)
      HStack {
        Text("Password").font(.headline)
        Spacer()
      }
      PasswordInput(content: $password)
      HStack {
        Text("RepeatPassword").font(.headline)
        Spacer()
      }
      PasswordInput(content: $password_rep)

      PasswordInfo(isOk: .constant(password.isLongEnough())) {
        Text("At least six signs")
      }

      PasswordInfo(isOk: .constant(password.containsDigits())) {
        Text("Digits")
      }
      PasswordInfo(isOk: .constant(password.containsLargeLetters())) {
        Text("Capital Letters")
      }
      PasswordInfo(isOk: .constant(password.containsSmallLetters())) {
        Text("Small Letters")
      }
      PasswordInfo(isOk: .constant(password.containsSpecialCharacters())) {
        Text("Special Characters")
      }

      PasswordInfo(isOk: .constant(password_rep == password)) {
        Text("Passwords are the same")
      }

      ButtonComponentChatee(
        title: {
          Text("Create Account")
        },
        style: .wide
      ) { onFinish in

        guard
          let privKey = try? self.appModel.endpointContainer.cryptoApi
            .privKeyNewPbkdf2(
              password: username, salt: password)
        else { return }
        guard
          let pubKey = try? self.appModel.endpointContainer.cryptoApi
            .pubKeyNew(from: privKey)
        else { return }
        self.appModel.privkey = privKey
        self.appModel.apiConnect?.register(
          inviteToken: self.invitationtoken, username: self.username,
          publicKey: pubKey
        ) { res in
          ApplicationStateManager.global?.enter(AuthorizingState.self)
          onFinish()
        }
      }

      ButtonComponentChateeText(
        title: {
          Text("Cancel")
        },
        style: .wide
      ) { onFinish in
        ApplicationStateManager.global?.enter(LoginScreenDisplayState.self)
        onFinish()
      }

      Spacer()
    }.padding(40).interactiveDismissDisabled(true)

  }
}
