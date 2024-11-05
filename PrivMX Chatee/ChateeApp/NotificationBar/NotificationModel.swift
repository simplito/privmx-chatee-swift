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

@MainActor
public class NotificationModel: ObservableObject {
  @Published public var content: String?
  init() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(showToast), name: NSNotification.DefaultToast,
      object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(handleError), name: NSNotification.CriticalError,
      object: nil)
  }

  @objc func handleError(notification: NSNotification) {
    ApplicationStateManager.global?.enter(
      PlatformConenctionErrorState.self)
  }

  @objc func showToast(notification: NSNotification) {
    withAnimation {
      DispatchQueue.main.async {
          self.content = notification.userInfo?["content"] as? String
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(5))) {
      withAnimation {
        DispatchQueue.main.async {
          self.content = nil
        }
      }
    }
  }
}
