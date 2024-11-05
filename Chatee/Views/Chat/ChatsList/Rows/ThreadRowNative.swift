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

struct ThreadRowNative: View {
	var leadingColor: Color
	var secondColor: Color
	var threadTitle: String
	var threadSubtitle: String

	var body: some View {
		HStack {
			VStack {

				HStack {
					Text("\(threadTitle)").fontWeight(.bold).foregroundColor(
						leadingColor)
					Spacer()
				}

				HStack {
					Text(threadSubtitle).multilineTextAlignment(.leading)
						.foregroundColor(secondColor)
					Spacer()
				}
			}
			Spacer()
		}.padding()

	}
}
