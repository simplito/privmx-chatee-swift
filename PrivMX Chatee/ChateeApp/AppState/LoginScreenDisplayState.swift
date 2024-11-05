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

class LoginScreenDisplayState: AppState {

  var appModel: AppModel

  init(show: Binding<Bool>, appModel: AppModel) {
    self.appModel = appModel
    super.init(show: show)
  }

  override func didEnter() {
    super.didEnter()
    if !self.appModel.endpointContainer.endpoints.isEmpty {

      self.appModel.setup(
        endpointName: ENDPOINT_NAME,
        domain: self.appModel.apiConnect?.fulldomain ?? "",
        password: "",
        privkey: "",
        login: "",
        pubKey: ""
      )
    }
  }

}
