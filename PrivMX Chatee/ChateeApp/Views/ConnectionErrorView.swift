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

struct ConnectionErrorView: View {

  var body: some View {

    VStack(spacing: 10) {
      Spacer()
      LoadingIndicator()
      Spacer()
    }.padding(40)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(2))) {
          ApplicationStateManager.global?.enter(LoginScreenDisplayState.self)
        }
      }

  }
}
