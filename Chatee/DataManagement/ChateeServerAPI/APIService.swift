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

public struct APIService<T> {
	let id: String
	let tag: String
	let method: String
	let path: String
	let hasBody: Bool

	init(id: String, tag: String, method: String, path: String, hasBody: Bool) {
		self.id = id
		self.tag = tag
		self.method = method
		self.path = path
		self.hasBody = hasBody
	}
}
