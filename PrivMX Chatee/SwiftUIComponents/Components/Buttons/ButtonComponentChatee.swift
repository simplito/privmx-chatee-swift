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

public struct ButtonComponentChatee<Row>: View where Row: View {
  @Environment(\.colorScheme) var colorScheme
  var style: ButtonComponentStyle = .normal
  var action: (@escaping () -> Void) -> Void
  @ViewBuilder var title: () -> Row

  public init(
    title: @escaping () -> Row, style: ButtonComponentStyle,
    action: @escaping (@escaping () -> Void) -> Void
  ) {
    self.style = style
    self.action = action
    self.title = title
  }

  public var body: some View {
    ButtonComponent(
      color: ColorProviderTool.def.buttonBackgrouund(colorScheme),
      action: { onFinish in
        action(onFinish)
      }
    ) {

      HStack {
        if style == .wide {
          Spacer()
        }

        title().foregroundColor(ColorProviderTool.def.buttonFront(colorScheme))
        if style == .wide {
          Spacer()
        }
      }
    }
  }
}
