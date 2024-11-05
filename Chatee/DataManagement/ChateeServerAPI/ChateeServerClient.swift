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

import Alamofire
import Foundation
 
public class ChateeServerClient {

	public var baseURL: String

	public var sessionManager: Session

	public var defaultHeaders: [String: String]

	public var jsonDecoder = JSONDecoder()
	public var jsonEncoder = JSONEncoder()

	 
	public init(
		baseURL: String, sessionManager: Session = .default,
		defaultHeaders: [String: String] = [:]

	) {
		self.baseURL = baseURL
		self.sessionManager = sessionManager
		self.defaultHeaders = defaultHeaders

	}

	func makeRequest<T: Decodable, S: Encodable>(_ request: ApiRequest<T, S>) async -> Result<
		T, Error
	> {

		guard let url = URL(string: "\(baseURL)\(request.service.path)") else {
			return Result.failure(ApiError.invalidURL)
		}

		var urlrequest = URLRequest(url: url)
		urlrequest.httpMethod = request.service.method

		for (key, value) in defaultHeaders {
			urlrequest.setValue(value, forHTTPHeaderField: key)
		}
		if request.service.hasBody {
			urlrequest.httpBody = try? jsonEncoder.encode(request.body)
		}

		guard let (data, _) = try? await URLSession.shared.data(for: urlrequest) else {
			return Result.failure(ApiError.invalidRequest)
		}

		if let result = try? jsonDecoder.decode(T.self, from: data) {
			return Result.success(result)
		} else {
			return Result.failure(ApiError.invalidResponse)
		}

	}

}

public enum ApiError: Error {
	case invalidURL
	case invalidRequest
	case invalidResponse
	case invalidData
}
