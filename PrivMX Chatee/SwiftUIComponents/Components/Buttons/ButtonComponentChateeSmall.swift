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

public struct ButtonComponentChateeSmall<Row>: View where Row: View {
  @Environment(\.colorScheme) var colorScheme

  @ViewBuilder var title: () -> Row
  var style: ButtonComponentStyle = .normal
  var action: () -> Void

  public init(title: @escaping () -> Row, style: ButtonComponentStyle, action: @escaping () -> Void)
  {

    self.title = title
    self.style = style
    self.action = action
  }

  public var body: some View {
    ButtonComponentSmall(
      color: ColorProviderTool.def.buttonBackgrouund(colorScheme),
      action: {
        action()
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
