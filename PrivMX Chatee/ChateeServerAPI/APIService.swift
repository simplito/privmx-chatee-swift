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

public struct APIService<ResponseType: APIResponseValue> {

  public let id: String
  public let tag: String
  public let method: String
  public let path: String
  public let hasBody: Bool
  public let isUpload: Bool
  public let securityRequirements: [SecurityRequirement]

  public init(
    id: String, tag: String = "", method: String, path: String, hasBody: Bool,
    isUpload: Bool = false, securityRequirements: [SecurityRequirement] = []
  ) {
    self.id = id
    self.tag = tag
    self.method = method
    self.path = path
    self.hasBody = hasBody
    self.isUpload = isUpload
    self.securityRequirements = securityRequirements
  }
}

extension APIService: CustomStringConvertible {

  public var name: String {
    return "\(tag.isEmpty ? "" : "\(tag).")\(id)"
  }

  public var description: String {
    return "\(name): \(method) \(path)"
  }
}

public struct SecurityRequirement {
  public let type: String
  public let scopes: [String]

  public init(type: String, scopes: [String]) {
    self.type = type
    self.scopes = scopes
  }
}
