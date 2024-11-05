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
import SwiftUI

public struct TextInputWithPlaceholder: View {
	var text: String
	@Binding var content: String

	public init(text: String, content: Binding<String>) {
		self.text = text
		self._content = content
	}

	public var body: some View {

		HStack {

			TextField(text: $content) {
				Text(text)
			}
		}
		.textFieldStyle(RoundedBorderTextFieldStyle())

	}
}
