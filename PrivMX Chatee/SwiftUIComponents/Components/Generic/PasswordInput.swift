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

public struct PasswordInput: View {
  @Environment(\.colorScheme) var colorScheme
  @Binding var content: String

  public init(content: Binding<String>) {
    self._content = content
  }

  public var body: some View {
    HStack {
      HStack {

        SecureField(text: $content) {

        }.border(.clear)
      }
      .textFieldStyle(PlainTextFieldStyle())
      .padding(10)
    }.overlay {
      VStack {
        RoundedRectangle(cornerRadius: 5).stroke(
          ColorProviderTool.def.frame(colorScheme), lineWidth: 1)
      }.padding(1)
    }
  }
}
