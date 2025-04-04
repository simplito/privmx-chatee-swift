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

public struct InviteTokenResponse: Codable, Sendable {

	public var value: String
	public var creationDate: Int
	public var isStaff: Bool
	public var isUsed: Bool
	public var domain: String

}
