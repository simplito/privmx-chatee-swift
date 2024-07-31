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

import SwiftUI

public struct ColorBlended: ViewModifier {
  fileprivate var color: Color

  public func body(content: Content) -> some View {
    VStack {
      ZStack {
        content
        color.blendMode(.sourceAtop)
      }
      .drawingGroup(opaque: false)
    }
  }
}

extension View {
  public func blending(color: Color) -> some View {
    modifier(ColorBlended(color: color))
  }
}

extension Image {
  public func blending(color: Color) -> some View {
    modifier(ColorBlended(color: color))
  }
}
#if os(macOS)
  extension NSTextField {
    open override var focusRingType: NSFocusRingType {
      get { .none }
      set {}
    }
  }
#endif
