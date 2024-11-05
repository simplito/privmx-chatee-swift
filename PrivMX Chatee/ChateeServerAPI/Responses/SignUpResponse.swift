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

public class SignUpResponse: APIModel {

  public var message: String

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    message = try container.decode("message")
  }

  public init(message: String) {
    self.message = message
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(message, forKey: "message")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? SignUpResponse else { return false }

    guard self.message == object.message else { return false }
    return true
  }

  public static func == (lhs: SignUpResponse, rhs: SignUpResponse) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
