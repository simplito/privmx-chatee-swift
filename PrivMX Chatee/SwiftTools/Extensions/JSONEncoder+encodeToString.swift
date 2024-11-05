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

extension JSONEncoder {
  public func encodeToString(_ object: Encodable) -> String {
    if let data = try? self.encode(object) {
      return String(data: data, encoding: .utf8) ?? ""
    } else {
      return ""
    }
  }

}
