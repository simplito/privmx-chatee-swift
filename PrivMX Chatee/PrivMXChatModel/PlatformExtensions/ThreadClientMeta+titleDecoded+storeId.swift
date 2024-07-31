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
import PrivMXEndpointSwiftNative
 

extension privmx.endpoint.thread.ThreadClientMeta {
  public var titleDecoded: String {
    if String(self.title) == "" {
      return "Unnamed Thread"
    }

    if let titleJson = String(self.title).data(using: .utf8),
      let decodedThreadInfo = try? JSONDecoder().decode(ThreadInfo.self, from: titleJson)
    {
      return decodedThreadInfo.name
    } else {
      return String(self.title)
    }

  }
  public var storeId: String? {
    if String(self.title) == "" {
      return nil
    }
    if let titleJson = String(self.title).data(using: .utf8),
      let decodedThreadInfo = try? JSONDecoder().decode(ThreadInfo.self, from: titleJson)
    {
      return decodedThreadInfo.storeId
    } else {
      return nil
    }

  }
  public var storeEnabled: Bool {
    if String(self.title) == "" {
      return false
    }

    if let titleJson = String(self.title).data(using: .utf8),
      let decodedThreadInfo = try? JSONDecoder().decode(ThreadInfo.self, from: titleJson)
    {
      return decodedThreadInfo.storeId != ""
    } else {
      return false
    }
  }
}
