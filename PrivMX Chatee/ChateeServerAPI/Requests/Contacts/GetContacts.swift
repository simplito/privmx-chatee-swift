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

extension API.Contacts {

  /**
    Contacts

    List of possible contacts
    */
  public enum GetContacts {

    public static let service = APIService<Response>(
      id: "getContacts", tag: "contacts", method: "GET", path: "/api/contacts", hasBody: false,
      securityRequirements: [SecurityRequirement(type: "http_bearer", scopes: [])])
    public final class Request: APIRequest<Response> {

      public init() {

        super.init(service: GetContacts.service)

      }
    }

    public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
      public typealias SuccessType = ContactsResponse

      /** OK */
      case status200(ContactsResponse)

      public var success: ContactsResponse? {
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
        case 200: self = try .status200(decoder.decode(ContactsResponse.self, from: data))
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
