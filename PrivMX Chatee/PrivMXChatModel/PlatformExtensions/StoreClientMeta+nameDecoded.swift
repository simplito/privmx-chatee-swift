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
import PrivMXEndpointSwiftNative
 

extension privmx.endpoint.store.StoreClientMeta {
  public var nameDecoded: String {
    if String(self.name) == "" {
      return "Unnamed Store"
    }

    if let nameJson = String(self.name).data(using: .utf8),
      let decodedInfo = try? JSONDecoder().decode(StoreThreadInfo.self, from: nameJson)
    {
      return decodedInfo.name
    } else {
      return String(self.name)
    }

  }
}
