//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//


import Foundation
import UniformTypeIdentifiers

@available(macOS 11.0, *)
extension String {
	public var utType: UTType {
		guard let x = self.split(separator: ".").last else { return UTType.data }
		return UTType(filenameExtension: "\(x)") ?? UTType.data
	}

	public var strMimeType: String {
		return utType.preferredMIMEType ?? "application/octet-stream"
	}
}
