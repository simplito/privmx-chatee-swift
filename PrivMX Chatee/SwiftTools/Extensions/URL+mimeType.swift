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
import UniformTypeIdentifiers

@available(macOS 11.0, *)
extension URL {

  public var mimeType: String {
    return UTType(filenameExtension: self.pathExtension)?.preferredMIMEType
      ?? "application/octet-stream"
  }
}
