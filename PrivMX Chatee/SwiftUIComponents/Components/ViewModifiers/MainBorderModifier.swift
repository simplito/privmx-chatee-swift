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

#if os(iOS)

  public struct MainBorderModifier: ViewModifier {
    var colorScheme: ColorScheme
    public func body(content: Content) -> some View {
      content

    }
  }

  public struct ButtonBorderModifier: ViewModifier {
    var colorScheme: ColorScheme
    public func body(content: Content) -> some View {
      content
        .background(ColorProviderTool.def.backgroundLite(colorScheme))
        .cornerRadius(10.0)
        .overlay {
          VStack {
            RoundedRectangle(cornerRadius: 10).stroke(
              ColorProviderTool.def.frame(colorScheme), lineWidth: 1)
          }
        }
    }
  }
#endif

#if os(macOS)

  public struct MainBorderModifier: ViewModifier {
    var colorScheme: ColorScheme
    public func body(content: Content) -> some View {
      content
        .background(ColorProviderTool.def.backgroundLite(colorScheme))
        .cornerRadius(10.0)
        .overlay {
          VStack {
            RoundedRectangle(cornerRadius: 10).stroke(
              ColorProviderTool.def.frame(colorScheme), lineWidth: 1)
          }
        }.padding()
    }
  }

  public struct ButtonBorderModifier: ViewModifier {
    var colorScheme: ColorScheme
    public func body(content: Content) -> some View {
      content
        .background(ColorProviderTool.def.backgroundLite(colorScheme))
        .cornerRadius(10.0)
        .overlay {
          VStack {
            RoundedRectangle(cornerRadius: 10).stroke(
              ColorProviderTool.def.frame(colorScheme), lineWidth: 1)
          }
        }
    }
  }

#endif

extension View {
  public func border(colorScheme: ColorScheme) -> some View {
    modifier(ButtonBorderModifier(colorScheme: colorScheme))
  }
  public func mainBorder(colorScheme: ColorScheme) -> some View {
    modifier(MainBorderModifier(colorScheme: colorScheme))
  }
}
