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

struct SideButton: View {
  var name: String
  var tint: Color
  var onClick: () -> Void

  var body: some View {
    Button(action: {
      onClick()
    }) {
      Image(systemName: name).resizable()
        .scaledToFit().frame(width: 20, height: 20)
    }.tint(tint)
  }

}
