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

public class CloudDataResponse: APIModel {

  public var solutionId: String
  public var contextId: String
  public var platformUrl: String

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)

    solutionId = try container.decode("solutionId")
    contextId = try container.decode("contextId")
    platformUrl = try container.decode("platformUrl")

  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)

    try container.encode(solutionId, forKey: "solutionId")

    try container.encode(contextId, forKey: "contextId")
    try container.encode(platformUrl, forKey: "platformUrl")
  }

  public func isEqual(to object: Any?) -> Bool {
    guard let object = object as? CloudDataResponse else { return false }
    guard self.solutionId == object.solutionId else { return false }
    guard self.contextId == object.contextId else { return false }
    guard self.platformUrl == object.platformUrl else { return false }

    return true
  }

  public static func == (lhs: CloudDataResponse, rhs: CloudDataResponse) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}
