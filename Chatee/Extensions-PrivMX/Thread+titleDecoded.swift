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

	public var titleDecoded: String {

		if let titleJson = self.privateMeta.getData(),
			let decodedThread = try? JSONDecoder().decode(
				ThreadPrivateMeta.self, from: titleJson)
		{
			return decodedThread.name
		} else {
			return "Unnamed Thread"
		}

	}
	public var associatedStoreId: String? {

		if let titleJson = self.privateMeta.getData() as Data?,
			let decodedThread = try? JSONDecoder().decode(
				ThreadPrivateMeta.self, from: titleJson)
		{
			return decodedThread.storeId
		} else {
			return nil
		}
	}

	public var storeEnabled: Bool {
		if let titleJson = self.privateMeta.getData() as Data?,
			let decodedThread = try? JSONDecoder().decode(
				ThreadPrivateMeta.self, from: titleJson)
		{
			return decodedThread.storeId != ""
		} else {
			return false
		}
	}
}
