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

struct ChateeIcon: View {

  var body: some View {
    VStack {
      #if os(iOS)
        Image("1024x").resizable().scaledToFit().cornerRadius(5)
        VerticalSpacer(size: 30)
      #endif

      #if os(macOS)
        Image("1024").resizable().scaledToFit().frame(maxHeight: 300)
          .cornerRadius(5)
      #endif
    }
  }
}
