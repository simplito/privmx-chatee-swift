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

public class ContactResponse: APIModel {

  public var isStaff: Bool
  public var username: String
  public var publicKey: String

  init(isStaff: Bool, _id: String, username: String, publicKey: String) {
    self.isStaff = isStaff

    self.username = username
    self.publicKey = publicKey
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    isStaff = try container.decode("isStaff")

    username = try container.decode("username")
    publicKey = try container.decode("publicKey")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(isStaff, forKey: "isStaff")

    try container.encode(username, forKey: "username")
    try container.encode(publicKey, forKey: "publicKey")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? ContactResponse else { return false }

    guard self.isStaff == object.isStaff else { return false }

    guard self.username == object.username else { return false }
    guard self.publicKey == object.publicKey else { return false }

    return true
  }

  public static func == (lhs: ContactResponse, rhs: ContactResponse) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
