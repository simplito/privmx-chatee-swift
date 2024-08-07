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

import Alamofire
import Foundation

public protocol APIResponseValue: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  var statusCode: Int { get }
  var successful: Bool { get }
  var response: Any { get }
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
  var success: SuccessType? { get }
}

public enum APIResponseResult<SuccessType, FailureType>: CustomStringConvertible,
  CustomDebugStringConvertible
{
  case success(SuccessType)
  case failure(FailureType)

  public var value: Any {
    switch self {
    case .success(let value): return value
    case .failure(let value): return value
    }
  }

  public var successful: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }

  public var description: String {
    return "\(successful ? "success" : "failure")"
  }

  public var debugDescription: String {
    return "\(description):\n\(value)"
  }
}

public struct APIResponse<T: APIResponseValue> {

  /// The APIRequest used for this response
  public let request: APIRequest<T>

  /// The result of the response .
  public let result: APIResult<T>

  /// The URL request sent to the server.
  public let urlRequest: URLRequest?

  /// The server's response to the URL request.
  public let urlResponse: HTTPURLResponse?

  /// The data returned by the server.
  public let data: Data?

  /// The timeline of the complete lifecycle of the request.
  public let metrics: URLSessionTaskMetrics?

  init(
    request: APIRequest<T>, result: APIResult<T>, urlRequest: URLRequest? = nil,
    urlResponse: HTTPURLResponse? = nil, data: Data? = nil, metrics: URLSessionTaskMetrics? = nil
  ) {
    self.request = request
    self.result = result
    self.urlRequest = urlRequest
    self.urlResponse = urlResponse
    self.data = data
    self.metrics = metrics
  }
}

extension APIResponse: CustomStringConvertible, CustomDebugStringConvertible {

  public var description: String {
    var string = "\(request)"

    switch result {
    case .success(let value):
      string += " returned \(value.statusCode)"
      let responseString = "\(type(of: value.response))"
      if responseString != "()" {
        string += ": \(responseString)"
      }
    case .failure(let error): string += " failed: \(error)"
    }
    return string
  }

  public var debugDescription: String {
    var string = description
    if let response = try? result.get().response {
      if let debugStringConvertible = response as? CustomDebugStringConvertible {
        string += "\n\(debugStringConvertible.debugDescription)"
      }
    }
    return string
  }
}
