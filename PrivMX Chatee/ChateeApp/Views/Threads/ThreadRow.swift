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
 
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative
import SwiftUI

struct ThreadRow: View {
  @Environment(\.colorScheme) var colorScheme

  @EnvironmentObject var threadsModel: ThreadsModel
  @State var thread: privmx.endpoint.thread.ThreadInfo

  @Binding var selected: String
  var body: some View {
    VStack {

      NavigationLink(
        destination: VStack {
          ThreadView(thread: thread, selected: $selected)
            .environmentObject(threadsModel.threadModel)
        }
      ) {
        VStack(spacing: 0) {
          if selected == thread.threadId.toString() {
            ThreadRowNativeSelected(
              leadingColor: .frontPrimary(colorScheme),
              secondColor: .frontSecondary(colorScheme),
              threadTitle: thread.data.titleDecoded,
              threadSubtitle: $thread.wrappedValue.userList()
            )
          } else {
            ThreadRowNative(
              leadingColor: .frontPrimary(colorScheme),
              secondColor: .frontSecondary(colorScheme),
              threadTitle: thread.data.titleDecoded,
              threadSubtitle: $thread.wrappedValue.userList()
            )
          }
        }

      }.buttonStyle(.borderless)
        .border(colorScheme: colorScheme)

    }.padding(1)
      .padding(.bottom, 10)

  }
}
