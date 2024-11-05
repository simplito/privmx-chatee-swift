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

public enum APIClientError: Error {
  case unexpectedStatusCode(statusCode: Int, data: Data)
  case decodingError(DecodingError)
  case requestEncodingError(Error)
  case validationError(Error)
  case networkError(Error)
  case unknownError(Error)

  public var name: String {
    switch self {
    case .unexpectedStatusCode: return "Unexpected status code"
    case .decodingError: return "Decoding error"
    case .validationError: return "Request validation failed"
    case .requestEncodingError: return "Request encoding failed"
    case .networkError: return "Network error"
    case .unknownError: return "Unknown error"
    }
  }
}

extension APIClientError: CustomStringConvertible {

  public var description: String {
    switch self {
    case .unexpectedStatusCode(let statusCode, _): return "\(name): \(statusCode)"
    case .decodingError(let error): return "\(name): \(error.localizedDescription)\n\(error)"
    case .validationError(let error): return "\(name): \(error.localizedDescription)"
    case .requestEncodingError(let error): return "\(name): \(error)"
    case .networkError(let error): return "\(name): \(error.localizedDescription)"
    case .unknownError(let error): return "\(name): \(error.localizedDescription)"
    }
  }
}
