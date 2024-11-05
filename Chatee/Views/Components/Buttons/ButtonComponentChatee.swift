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

@MainActor @preconcurrency public struct ButtonComponentChatee<Row>: View where Row: View {
	@Environment(\.colorScheme) var colorScheme
	var style: ButtonComponentStyle = .normal
	var action: @MainActor (@escaping @MainActor () -> Void) -> Void
	@ViewBuilder var title: () -> Row

	@preconcurrency public init(
		title: @escaping () -> Row, style: ButtonComponentStyle,
		action: @escaping @MainActor (@escaping @MainActor () -> Void) -> Void
	) {
		self.style = style
		self.action = action
		self.title = title
	}

	@MainActor @preconcurrency public var body: some View {
		ButtonComponent(
			color: ColorProviderTool.def.buttonBackgrouund(colorScheme),
			action: { onFinish in
				action(onFinish)
			}
		) {
			HStack {
				if style == .wide {
					Spacer()
				}

				title().foregroundColor(
					ColorProviderTool.def.buttonFront(colorScheme))
				if style == .wide {
					Spacer()
				}
			}
		}
	}
}
