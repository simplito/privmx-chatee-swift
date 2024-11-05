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

public class InviteTokenBody: APIModel {

  public var isStaff: Bool
  public var domainName: String

  public init(isStaff: Bool, domainName: String) {
    self.isStaff = isStaff
    self.domainName = domainName
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    self.isStaff = try container.decode("isStaff")
    self.domainName = try container.decode("domainName")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(isStaff, forKey: "isStaff")
    try container.encode(domainName, forKey: "domainName")

  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? InviteTokenBody else { return false }
    guard self.isStaff == object.isStaff else { return false }
    guard self.domainName == object.domainName else { return false }
    return true
  }

  public static func == (lhs: InviteTokenBody, rhs: InviteTokenBody) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
