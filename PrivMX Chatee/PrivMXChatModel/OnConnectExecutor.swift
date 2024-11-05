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

public class OnConnectExecutor {
  private var onConnectFuncs = [() -> Void]()
  public func onConnect(_ fun: @escaping () -> Void) {
    onConnectFuncs.append(fun)
  }
  public func performOnConnect() {
    for fun in onConnectFuncs {
      fun()
    }
  }
}
