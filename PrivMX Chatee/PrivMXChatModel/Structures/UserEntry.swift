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

public struct UserEntry {
  public var id: UUID
  public var name: String
  public var publicKey: String

  public init(name: String, publicKey: String) {
    self.id = UUID()
    self.name = name
    self.publicKey = publicKey
  }
}
