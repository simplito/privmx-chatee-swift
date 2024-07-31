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

public class SignInBody: APIModel {

  public var sign: String
  public var domainName: String
  public var username: String

  public init(sign: String, domainName: String, username: String) {
    self.sign = sign
    self.domainName = domainName
    self.username = username
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    sign = try container.decode("sign")
    domainName = try container.decode("domainName")
    username = try container.decode("username")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(sign, forKey: "sign")
    try container.encode(username, forKey: "username")
    try container.encode(domainName, forKey: "domainName")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? SignInBody else { return false }
    guard self.sign == object.sign else { return false }
    guard self.username == object.username else { return false }
    guard self.domainName == object.domainName else { return false }
    return true
  }

  public static func == (lhs: SignInBody, rhs: SignInBody) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
