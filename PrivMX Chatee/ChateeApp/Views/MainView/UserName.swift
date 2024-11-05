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
import SwiftUI

struct UserName: View {
  @Environment(\.colorScheme) var colorScheme
  var user: UserEntryAdmin
  var body: some View {
    Text("\(user.name)").foregroundStyle(Color.frontPrimary(colorScheme))
    if user.isStaff {
      HStack {
        Text("STAFF").font(.subheadline).foregroundStyle(Color.frontSecondary(colorScheme))
      }.padding([.leading, .trailing], 10)
        .border(colorScheme: colorScheme)
    }
  }
}
