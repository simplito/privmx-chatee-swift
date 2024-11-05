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

/// Helper extension, managing conversion between Model UserEntry privmx.endpoint.core.UserWithPubKey
extension [UserEntry] {
  func toUserWithPubKey() -> [privmx.endpoint.core.UserWithPubKey] {
    var uwpman = [privmx.endpoint.core.UserWithPubKey]()
    for user in self {
      var uwpk = privmx.endpoint.core.UserWithPubKey()
      uwpk.pubKey = std.__1.string(user.publicKey)
      uwpk.userId = std.__1.string(user.name)
      uwpman.append(uwpk)
    }
    return uwpman
  }
}
