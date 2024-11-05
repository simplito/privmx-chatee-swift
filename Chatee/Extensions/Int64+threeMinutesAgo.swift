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

extension Int64 {
	func threeMinutesAgo() -> String {
		let original = TimeInterval(self / 1000)
		let now = Date().timeIntervalSince1970
		let dif = now - original
		return "\(dif.threeminutes)"

	}

	func convertInt64ToDate() -> String? {
		let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

		let formattedDate = dateFormatter.string(from: date)

		return formattedDate
	}
}
