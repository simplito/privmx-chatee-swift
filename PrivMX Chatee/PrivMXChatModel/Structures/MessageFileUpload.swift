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

public struct MessageFileUpload: Codable {
  public var type: String
  public var storeId: String
  public var fileId: String
  public var fileName: String
  public var fileMimeType: String
  public init(type: String, storeId: String, fileId: String, fileName: String, fileMimeType: String)
  {
    self.type = type
    self.storeId = storeId
    self.fileId = fileId
    self.fileName = fileName
    self.fileMimeType = fileMimeType
  }
}
