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

@MainActor @preconcurrency public struct ButtonComponentSmall<X: View>: View {
	var color: Color
	var action: @MainActor (@escaping @MainActor () -> Void) -> Void
	var content: () -> X

	@MainActor @preconcurrency public var body: some View {
		Button(
			action: {
				action {

				}
			},
			label: {
				HStack {
					content()
				}
				.padding(5)
			}
		)
		.buttonStyle(.borderless)
		.background(color)
		.cornerRadius(5.0)
	}
}
