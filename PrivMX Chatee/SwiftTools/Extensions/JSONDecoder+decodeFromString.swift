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

extension JSONDecoder {
  public func decode<T>(_ type: T.Type, from string: String) throws -> T? where T: Decodable {
    if let data = string.data(using: .utf8) {
      return try self.decode(type, from: data)
    }
    return nil
  }
}
