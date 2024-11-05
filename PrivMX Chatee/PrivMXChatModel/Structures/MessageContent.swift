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

public struct MessageContent: Codable {
	public var type: String
	public var text: String
	public init(type: String, text: String) {
		self.type = type
		self.text = text
	}
	
	public var content :String {return text}
}
