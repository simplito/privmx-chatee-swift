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

extension API.Contacts {

	public struct GetContacts {

		nonisolated(unsafe)
		public static let service = APIService<ContactsResponse>(
			id: "getContacts", tag: "contacts", method: "GET", path: "/api/contacts",
			hasBody: false)

		public class Request: ApiRequest<ContactsResponse, EmptyBody> {
			public init(body: EmptyBody) {
				super.init(service: GetContacts.service, body: body)
			}
		}
	}

}
