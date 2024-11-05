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

import SwiftUI

struct AvatarSmall: View {
	@Environment(\.colorScheme) var colorScheme
	@Binding var author: String
	var body: some View {
		VStack {

			Text(String(author.first!)).font(.subheadline).foregroundStyle(
				Color.userColor(name: author))

		}.frame(width: 20, height: 20)
			.background(Color.userColor(name: author).opacity(0.2)).opacity(0.8)
			.cornerRadius(10)
	}
}
