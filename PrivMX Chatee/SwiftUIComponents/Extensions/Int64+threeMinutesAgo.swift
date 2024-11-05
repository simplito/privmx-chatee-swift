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

extension Int64 {
  func threeMinutesAgo() -> String {
    // Convert int64 to Date
    let original = TimeInterval(self / 1000)
    let now = Date().timeIntervalSince1970
    let dif = now - original
    return "\(dif.threeminutes)"

  }

  func convertInt64ToDate() -> String? {
    // Convert int64 to Date
    let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))

    // Create a DateFormatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    // Convert Date to formatted string
    let formattedDate = dateFormatter.string(from: date)

    return formattedDate
  }
}
