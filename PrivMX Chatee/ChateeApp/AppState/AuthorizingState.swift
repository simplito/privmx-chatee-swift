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

class AuthorizingState: AppState {
  var appModel: AppModel
  init(appModel: AppModel) {
    self.appModel = appModel
    super.init(show: .constant(false))
  }

  override func didEnter() {
    super.didEnter()

    if let signed = try? self.appModel.endpointContainer.cryptoApi.sign(
      data: Data(self.appModel.login.utf8), key: self.appModel.privkey)
    {
      let hexed = signed.hexEncodedString()
      self.appModel.apiConnect?.login(username: self.appModel.login, key: hexed) { success in
        if success {
          if let pubKey = try? self.appModel.endpointContainer.cryptoApi.pubKeyNew(
            from: self.appModel.privkey)
          {
            self.appModel.pubKey = pubKey
          }
          do {
            if try self.appModel.setup() == .success {
              ApplicationStateManager.global?.enter(PlatformConnectingState.self)
            } else {
              ApplicationStateManager.global?.enter(PlatformConenctionErrorState.self)
            }
          } catch {
            ApplicationStateManager.global?.enter(PlatformConenctionErrorState.self)
          }
        } else {
          ApplicationStateManager.global?.enter(LoginScreenDisplayState.self)
        }
      }

    }
  }

}
