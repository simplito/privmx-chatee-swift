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
import SwiftUI

struct AuthorContentRow: View {

	@EnvironmentObject var messagesList: ThreadModel
	@State var author: String
	@State var date: String

	init(author: String, date: String) {
		self._author = State(initialValue: author)
		self._date = State(initialValue: date)
	}

	var body: some View {
		VStack(spacing: 0) {
			VerticalSpacer(size: 20)
			HStack(spacing: 0) {
				VStack {
					Avatar(author: .constant(String(author)))
				}.frame(width: 60, height: 25).offset(
					CGSize(width: 0.0, height: 15.0))

				HStack(spacing: 0) {
					Text(String(author)).font(.subheadline).fontWeight(.bold)
						.padding(.trailing, 10)

					Text(String(date)).font(.subheadline).opacity(0.8)
					Spacer()
				}

			}
		}

	}
}
