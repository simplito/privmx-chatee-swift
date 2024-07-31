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

struct ButtonComponent<X: View>: View {
  var color: Color
  var action: (@escaping () -> Void) -> Void
  var content: () -> X
  @State var inProgress = false
  var body: some View {

    Button(
      action: {
        self.inProgress = true
        action {
          self.inProgress = false
        }
      },
      label: {
        ZStack {
          HStack {
            content()
              .opacity(self.inProgress ? 0.5 : 1.0)
          }
          .padding(10)
          if inProgress {
            MyLoadingIndicationLight()
          }
        }
      }
    )
    .buttonStyle(.borderless)
    .background(color)
    .cornerRadius(5.0)
  }
}
