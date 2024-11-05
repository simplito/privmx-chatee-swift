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

@MainActor @preconcurrency public struct SideButton: View {
	var name: String
	var tint: Color
	var onClick: () -> Void

	@MainActor @preconcurrency public var body: some View {
		Button(action: {
			onClick()
		}) {
			Image(systemName: name).resizable()
				.scaledToFit().frame(width: 20, height: 20)
		}.tint(tint)
	}

}
