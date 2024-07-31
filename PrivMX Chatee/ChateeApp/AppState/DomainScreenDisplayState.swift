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

class DomainScreenDisplayState: AppState {

  override func didEnter() {
    super.didEnter()
    UserDefaults.standard.setValue(nil, forKey: "storedDomain")
  }

}
