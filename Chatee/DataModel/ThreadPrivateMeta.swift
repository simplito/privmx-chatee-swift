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

public struct ThreadPrivateMeta: Codable {
	var name: String
	var storeId: String
	public init(name: String, storeId: String) {
		self.name = name
		self.storeId = storeId
	}
}
