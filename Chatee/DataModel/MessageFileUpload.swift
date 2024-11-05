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
import SwiftUI

public struct MessageFileUpload: Codable {
	public var fileId: String
	public var fileName: String
	public init(fileId: String, fileName: String) {
		self.fileId = fileId
		self.fileName = fileName
	}
}
