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
import PrivMXEndpointSwiftNative

extension privmx.endpoint.thread.Thread {
	func hasModifyPermission(_ user: UserEntry?) -> Bool {
		guard let user = user else { return false }
		for manager in self.managers {
			if manager.toString() == user.name {
				return true
			}
		}
		return self.creator.toString() == user.name

	}
}
