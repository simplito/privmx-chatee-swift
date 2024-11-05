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

extension API.SignIn {

	public struct PostSignIn {

		nonisolated(unsafe)
		public static let service = APIService<SignInResponse>(
			id: "postSignIn", tag: "sign-in", method: "POST", path: "/api/sign-in",
			hasBody: true
		)

		public class Request: ApiRequest<SignInResponse, SignInBody> {
			public init(body: SignInBody) {
				super.init(service: PostSignIn.service, body: body)
			}
		}
	}

}
