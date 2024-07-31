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

public struct StoreThreadInfo: Codable {
  var name: String
  var threadCompanion: Bool
  var threadID: String?

  public init(name: String, threadCompanion: Bool, threadID: String? = nil) {
    self.name = name
    self.threadCompanion = threadCompanion
    self.threadID = threadID
  }
}
