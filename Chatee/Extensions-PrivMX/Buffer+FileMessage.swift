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

extension privmx.endpoint.core.Buffer {
	public var fileMessage: MessageFileUpload? {
		try? JSONDecoder().decode(MessageFileUpload.self, from: self.getData() ?? Data())

	}
	public var contentMessage: MessageContent? {
		 
		return 	try? JSONDecoder().decode(MessageContent.self, from: self.getData() ?? Data())

	}
}
