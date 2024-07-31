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

public class ContactsResponse: APIModel {

  public var contacts: [ContactResponse]

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    contacts = try container.decodeArray("contacts")
  }

  public init(contacts: [ContactResponse]) {
    self.contacts = contacts
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(contacts, forKey: "contacts")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? ContactsResponse else { return false }

    guard self.contacts == object.contacts else { return false }
    return true
  }

  public static func == (lhs: ContactsResponse, rhs: ContactsResponse) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
