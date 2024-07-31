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

public class SignInResponse: APIModel {

  public var isStaff: Bool
  public var token: String
  public var cloudData: CloudDataResponse

  init(isStaff: Bool, token: String, cloudData: CloudDataResponse) {
    self.isStaff = isStaff
    self.token = token
    self.cloudData = cloudData
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    token = try container.decode("token")
    cloudData = try container.decode("cloudData")
    isStaff = try container.decode("isStaff")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(token, forKey: "token")
    try container.encode(cloudData, forKey: "cloudData")
    try container.encode(isStaff, forKey: "isStaff")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? SignInResponse else { return false }

    guard self.token == object.token else { return false }
    guard self.cloudData == object.cloudData else { return false }
    guard self.isStaff == object.isStaff else { return false }
    return true
  }

  public static func == (lhs: SignInResponse, rhs: SignInResponse) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
