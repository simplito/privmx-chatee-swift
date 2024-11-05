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

/// This is api for the Chatee server.
public struct API {

  /// Whether to discard any errors when decoding optional properties
  public static var safeOptionalDecoding = false

  /// Whether to remove invalid elements instead of throwing when decoding arrays
  public static var safeArrayDecoding = false

  /// Used to encode Dates when uses as string params
  public static var dateEncodingFormatter = DateFormatter(
    formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
    locale: Locale(identifier: "en_US_POSIX"),
    calendar: Calendar(identifier: .gregorian))

  public static let version = "1.0.0"

  public enum SignIn {}
  public enum SignUp {}
  public enum InviteToken {}
  public enum Contacts {}

  // No servers defined in swagger. Documentation for adding them: https://swagger.io/specification/#schema
}
