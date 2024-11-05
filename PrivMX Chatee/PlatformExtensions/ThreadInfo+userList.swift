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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative
 

extension privmx.endpoint.thread.ThreadInfo {
  func userList() -> String {
    var users = ""
    for user in self.users {
      if users == "" {
        users = "\(user)"
      } else {
        users = "\(user) \(users)"
      }
    }
    return users
  }
}
