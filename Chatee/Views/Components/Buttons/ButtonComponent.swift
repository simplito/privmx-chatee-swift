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

struct ButtonComponent<X: View>: View {
	var color: Color
	var action: (@Sendable @escaping () -> Void) -> Void
	var content: () -> X
	@State var inProgress = false

	func setInProgress(_ inProgress: Bool) async {
		self.inProgress = inProgress
	}

	var body: some View {

		Button(
			action: {
				Task { await setInProgress(false) }
				action {
					Task { await setInProgress(false) }
				}
			},
			label: {
				ZStack {
					HStack {
						content()
							.opacity(self.inProgress ? 0.5 : 1.0)
					}
					.padding(10)
					if inProgress {
						MyLoadingIndicationLight()
					}
				}
			}
		)
		.buttonStyle(.borderless)
		.background(color)
		.cornerRadius(5.0)
	}
}
