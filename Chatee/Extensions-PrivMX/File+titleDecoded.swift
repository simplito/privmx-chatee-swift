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

extension privmx.endpoint.store.File {
	public var titleDecoded: String {

		if let titleJson = self.publicMeta.getData(),
			let decodedfilePrivateMeta = try? JSONDecoder().decode(
				FilePublicMeta.self, from: titleJson)
		{
			return decodedfilePrivateMeta.name
		} else {
			return "Unnamed file"
		}

	}
	public var authorName: String {
		info.author.toString()
	}
	public var dateCreated: String {
		info.createDate.convertInt64ToDate() ?? "Unknown creation date"
	}

	public var sizeInKB: String {
		"\(String(size / 1024)) KB"
	}

}
