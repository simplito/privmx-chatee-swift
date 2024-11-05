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

public struct Icon: View {
  var size: CGFloat
  var icon: String
  var color: Color

  public init(size: CGFloat, icon: String, color: Color) {
    self.size = size
    self.icon = icon
    self.color = color
  }

  public var body: some View {
    HStack {
      Image(icon).resizable().scaledToFit()
        .frame(width: size - 6, height: size - 6)
        .blending(color: color)
    }.frame(width: size, height: size)
  }
}
