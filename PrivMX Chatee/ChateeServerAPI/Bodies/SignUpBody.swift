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

public class SignUpBody: APIModel {

  public var inviteToken: String
  public var publicKey: String
  public var username: String

  public init(inviteToken: String, publicKey: String, username: String) {
    self.inviteToken = inviteToken
    self.publicKey = publicKey
    self.username = username
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    self.inviteToken = try container.decode("inviteToken")
    self.publicKey = try container.decode("publicKey")
    self.username = try container.decode("username")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(publicKey, forKey: "publicKey")
    try container.encode(inviteToken, forKey: "inviteToken")
    try container.encode(username, forKey: "username")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? SignUpBody else { return false }
    guard self.publicKey == object.publicKey else { return false }
    guard self.username == object.username else { return false }
    guard self.inviteToken == object.inviteToken else { return false }
    return true
  }

  public static func == (lhs: SignUpBody, rhs: SignUpBody) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
