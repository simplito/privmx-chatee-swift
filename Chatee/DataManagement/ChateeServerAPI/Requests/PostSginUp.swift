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

extension API.SignUp {

	public struct PostSignUp {

		nonisolated(unsafe)
		public static let service = APIService<SignUpResponse>(
			id: "postSignUp", tag: "sign-up", method: "POST", path: "/api/sign-up",
			hasBody: true)

		public class Request: ApiRequest<SignUpResponse, SignUpBody> {
			public init(body: SignUpBody) {
				super.init(service: PostSignUp.service, body: body)
			}
		}
	}

}
