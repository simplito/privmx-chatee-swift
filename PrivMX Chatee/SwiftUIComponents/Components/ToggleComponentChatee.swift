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

public struct ToggleComponentChatee<Row>: View where Row: View {
  @Environment(\.colorScheme) var colorScheme
  @Binding var isActive: Bool
  @ViewBuilder var title: () -> Row
  var style: ButtonComponentStyle = .normal
  var action: (@escaping () -> Void) -> Void

  public init(
    isActive: Binding<Bool>, title: @escaping () -> Row, style: ButtonComponentStyle,
    action: @escaping (@escaping () -> Void) -> Void
  ) {

    self._isActive = isActive
    self.title = title
    self.style = style
    self.action = action
  }

  public var body: some View {
    ButtonComponent(
      color: isActive
        ? ColorProviderTool.def.buttonFront(colorScheme)
        : ColorProviderTool.def.buttonBackgrouund(colorScheme),
      action: { onFinish in
        action(onFinish)
      }
    ) {

      HStack {
        if style == .wide {
          Spacer()
        }

        title().foregroundColor(
          isActive
            ? ColorProviderTool.def.buttonBackgrouund(colorScheme)
            : ColorProviderTool.def.buttonFront(colorScheme))
        if style == .wide {
          Spacer()
        }
      }
    }
  }
}
