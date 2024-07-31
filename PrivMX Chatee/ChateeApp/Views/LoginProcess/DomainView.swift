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

struct DomainView: View {

  @EnvironmentObject var appModel: AppModel

  var body: some View {

    VStack(spacing: 10) {
      Spacer()

      ChateeIcon()

      HStack {
        Text("What is Your Domain? ").font(.title)
        Spacer()
      }
      VerticalSpacer(size: 10)

      HStack {
        Text("Domain name").font(.headline)
        Spacer()
      }
      TextInput(content: $appModel.domain)

      ButtonComponentChatee(
        title: {
          Text("Next")
        },
        style: .wide
      ) { onFinish in
        if appModel.updateDomain() {
          UserDefaults.standard.setValue(
            appModel.domain, forKey: "storedDomain")
          ApplicationStateManager.global?.enter(
            LoginScreenDisplayState.self)
          onFinish()
        }
      }

      Spacer()

    }.padding(40).interactiveDismissDisabled(true)

  }
}
