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

struct ButtonComponentSmall<X: View>: View {
  var color: Color
  var action: () -> Void
  var content: () -> X

  var body: some View {
    Button(
      action: {
        action()
      },
      label: {
        HStack {
          content()
        }
        .padding(5)
      }
    )
    .buttonStyle(.borderless)
    .background(color)
    .cornerRadius(5.0)
  }
}
