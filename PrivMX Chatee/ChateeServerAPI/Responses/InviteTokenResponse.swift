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

public class InviteTokenResponse: APIModel {

  public var value: String
  public var creationDate: Int
  public var isStaff: Bool
  public var isUsed: Bool
  public var domain: String

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    value = try container.decode("value")
    creationDate = try container.decode("creationDate")
    isStaff = try container.decode("isStaff")
    isUsed = try container.decode("isUsed")
    domain = try container.decode("domain")
  }

  public init(value: String, creationDate: Int, isStaff: Bool, isUsed: Bool, domain: String) {
    self.value = value
    self.creationDate = creationDate
    self.isStaff = isStaff
    self.isUsed = isUsed
    self.domain = domain
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(value, forKey: "value")
    try container.encode(creationDate, forKey: "creationDate")
    try container.encode(isStaff, forKey: "isStaff")
    try container.encode(isUsed, forKey: "isUsed")
    try container.encode(domain, forKey: "domain")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? InviteTokenResponse else { return false }

    guard self.isStaff == object.isStaff else { return false }
    guard self.isUsed == object.isUsed else { return false }
    guard self.domain == object.domain else { return false }
    guard self.value == object.value else { return false }
    guard self.creationDate == object.creationDate else { return false }
    return true
  }

  public static func == (lhs: InviteTokenResponse, rhs: InviteTokenResponse) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
