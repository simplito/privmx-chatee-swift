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


extension API.InviteToken {

	public struct PostInviteToken {

		nonisolated(unsafe)
		public static let service = APIService<InviteTokenResponse>(
			id: "postInviteToken", tag: "invite-token", method: "POST",
			path: "/api/invite-token",
			hasBody: true)  

		public class Request: ApiRequest<InviteTokenResponse, InviteTokenBody> {
			public init(body: InviteTokenBody) {
				super.init(service: PostInviteToken.service, body: body)
			}
		}
	}

}
