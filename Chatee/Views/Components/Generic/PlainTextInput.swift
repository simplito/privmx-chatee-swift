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

public struct PlainTextInput<Row>: View where Row: View {
	@Environment(\.colorScheme) var colorScheme
	@Binding var content: String
	@ViewBuilder var row: () -> Row

	public init(content: Binding<String>, row: @escaping () -> Row) {

		self._content = content
		self.row = row
	}
	public var body: some View {
		HStack {
			HStack {

				TextField(text: $content) {
					row()
				}.focusablePadding()
			}
			.textFieldStyle(PlainTextFieldStyle())

		}
	}
}
