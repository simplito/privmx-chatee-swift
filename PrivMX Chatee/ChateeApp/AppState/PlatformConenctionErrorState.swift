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

class PlatformConenctionErrorState: AppState {
  var appModel: AppModel

  init(show: Binding<Bool>, appModel: AppModel) {
    self.appModel = appModel
    super.init(show: show)
  }
  override func didEnter() {
    super.didEnter()
    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(5))) {
      self.appModel.clearPasswordCache()
      ApplicationStateManager.global?.enter(LoginScreenDisplayState.self)
    }

  }
}
