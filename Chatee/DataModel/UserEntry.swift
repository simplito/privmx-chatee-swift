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

public struct UserEntry {
	public var id: UUID
	public var name: String
	public var publicKey: String
	public var isStaff: Bool

	public init(name: String, publicKey: String, isStaff: Bool) {
		self.id = UUID()
		self.name = name
		self.publicKey = publicKey
		self.isStaff = isStaff
	}
	public func authorOrStaff(autorName: String) -> Bool {
		autorName == self.name || self.isStaff
	}
}
