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

public struct StoreThread: Codable {
	var name: String
	var threadCompanion: Bool
	var threadID: String?

	public init(name: String, threadCompanion: Bool, threadID: String? = nil) {
		self.name = name
		self.threadCompanion = threadCompanion
		self.threadID = threadID
	}
}
