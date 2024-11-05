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

struct ButtonComponentChateeLight<Row>: View where Row: View {
  @Environment(\.colorScheme) var colorScheme

  @ViewBuilder var title: () -> Row
  var style: ButtonComponentStyle = .normal
  var action: (@escaping () -> Void) -> Void

  var body: some View {
    ButtonComponent(
      color: ColorProviderTool.def.buttonFront(colorScheme),
      action: { onFinish in
        action(onFinish)
      }
    ) {

      HStack {
        if style == .wide {
          Spacer()
        }

        title().foregroundColor(ColorProviderTool.def.buttonBackgrouund(colorScheme))
        if style == .wide {
          Spacer()
        }
      }
    }
  }
}
