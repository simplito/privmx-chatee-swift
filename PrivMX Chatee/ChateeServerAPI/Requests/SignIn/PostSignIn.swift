//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT Licence.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

extension API.SignIn {

  /**
    Authorize User

    Authorize user with the provided data
    */
  public enum PostSignIn {

    public static let service = APIService<Response>(
      id: "postSignIn", tag: "sign-in", method: "POST", path: "/api/sign-in", hasBody: true,
      securityRequirements: [])

    public final class Request: APIRequest<Response> {

      public var body: SignInBody

      public init(body: SignInBody, encoder: RequestEncoder? = nil) {
        self.body = body
        super.init(service: PostSignIn.service) { defaultEncoder in
          return try (encoder ?? defaultEncoder).encode(body)
        }
      }
    }

    public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
      public typealias SuccessType = SignInResponse

      /** OK */
      case status200(SignInResponse)

      public var success: SignInResponse? {
        switch self {
        case .status200(let response): return response
        }
      }

      public var response: Any {
        switch self {
        case .status200(let response): return response
        }
      }

      public var statusCode: Int {
        switch self {
        case .status200: return 200
        }
      }

      public var successful: Bool {
        switch self {
        case .status200: return true
        }
      }

      public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
        switch statusCode {
        case 200: self = try .status200(decoder.decode(SignInResponse.self, from: data))
        default: throw APIClientError.unexpectedStatusCode(statusCode: statusCode, data: data)
        }
      }

      public var description: String {
        return "\(statusCode) \(successful ? "success" : "failure")"
      }

      public var debugDescription: String {
        var string = description
        let responseString = "\(response)"
        if responseString != "()" {
          string += "\n\(responseString)"
        }
        return string
      }
    }
  }
}
