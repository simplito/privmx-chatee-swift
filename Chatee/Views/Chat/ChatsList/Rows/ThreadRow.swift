//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
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
	@State var thread: privmx.endpoint.thread.Thread
	@Binding var selectedThread: privmx.endpoint.thread.Thread?
	var body: some View {
		VStack {

			if selectedThread?.threadId.toString() == thread.threadId.toString() {
				ThreadRowNativeSelected(
					leadingColor: .frontPrimary(colorScheme),
					secondColor: .frontSecondary(colorScheme),
					threadTitle: $thread.wrappedValue.titleDecoded,
					threadSubtitle: $thread.wrappedValue.userList()
				).border(colorScheme: colorScheme)
			} else {
				ThreadRowNative(
					leadingColor: .frontPrimary(colorScheme),
					secondColor: .frontSecondary(colorScheme),
					threadTitle: thread.titleDecoded,
					threadSubtitle: $thread.wrappedValue.userList()
				).border(colorScheme: colorScheme)
			}

		}.padding(1)
			.padding(.bottom, 10)
			.onTapGesture {
				self.selectedThread = thread
			}

	}
}
