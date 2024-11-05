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

struct LoadingRow<T>: View where T: Identifiable & Hashable & Sendable {
  @EnvironmentObject var m: ListModel<T>
  var body: some View {
    HStack {
      LoadingIndicator().onAppear {
        DispatchQueue.main.asyncAfter(
          deadline: .now().advanced(by: .seconds(5))
        ) {
          self.m.loadNext()
        }
      }
    }
  }
}
