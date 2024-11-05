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

extension String {

  func cleanDomain() -> String? {
    let removedhttp = self.replacing("http://", with: "").replacing("https://", with: "")
    let tolowers = removedhttp.lowercased()
    let mainpart = tolowers.split(separator: "/").first
    let domaincandidate = "\(mainpart ?? "")"
    if domaincandidate.isValidDomain() {
      return domaincandidate
    } else {
      return nil
    }
  }
}
