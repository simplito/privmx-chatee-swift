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

@MainActor
class ApplicationStateManager: ObservableObject {
  static var global: ApplicationStateManager?
  var states: [AppState]
  var active: AppState.Type?

  init(states: [AppState]) {
    self.states = states
  }

  func enter(_ stateType: AppState.Type) {
    if let currentType = active {
      if currentType == stateType {
        return
      }
      for state in states {
        if type(of: state) == currentType {
          state.willExit()
        }
      }
    }
    for state in states {
      if type(of: state) == stateType {
        state.didEnter()
      }
    }
    self.active = stateType
  }
}
