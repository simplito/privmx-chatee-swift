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

class GeneratingPrivateKeyState: AppState {

  var appModel: AppModel

  init(appModel: AppModel) {
    self.appModel = appModel
    super.init(show: .constant(false))
  }

  override func didEnter() {
    super.didEnter()
    //DispatchQueue.main.async {
      do {
          self.appModel.set(privKey:try self.appModel.endpointContainer.cryptoApi.privKeyNewPbkdf2(
            password: self.appModel.login, salt: self.appModel.password))

      } catch {
        ApplicationStateManager.global?.enter(PlatformConenctionErrorState.self)
      }
    //}

    ApplicationStateManager.global?.enter(AuthorizingState.self)
  }
}
