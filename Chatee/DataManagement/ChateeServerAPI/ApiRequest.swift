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

public class ApiRequest<ResponseType: Decodable, RequestType: Encodable> {
	public var body: RequestType
	var service: APIService<ResponseType>
	init(service: APIService<ResponseType>, body: RequestType) {
		self.service = service
		self.body = body
	}
}
