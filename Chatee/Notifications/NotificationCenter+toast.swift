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

extension NotificationCenter {
	static func toast(_ content: String) {
		NotificationCenter.default.post(
			name: NSNotification.DefaultToast, object: nil,
			userInfo: ["content": content])
	}
	static func critical(in function: String) {
		NotificationCenter.default.post(
			name: NSNotification.CriticalError, object: nil,
			userInfo: ["function": function])
	}
}
