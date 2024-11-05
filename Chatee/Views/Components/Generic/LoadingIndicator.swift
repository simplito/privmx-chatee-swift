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

public struct LoadingIndicator: View {
	@Environment(\.colorScheme) var colorScheme

	private var rotateAnimation: Animation {
		Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
	}
	@State private var isAnimating = false

	public init(isAnimating: Bool = false) {
		self.isAnimating = isAnimating
	}

	public var body: some View {

		Icon(
			size: 25, icon: "loader-2",
			color: ColorProviderTool.def.buttonBackgrouund(colorScheme)
		)

		.rotationEffect(Angle(degrees: isAnimating ? 360 : -360))
		.animation(rotateAnimation, value: isAnimating)

		.onAppear {
			isAnimating = true
		}
	}
}

public struct MyLoadingIndicationLight: View {
	@Environment(\.colorScheme) var colorScheme

	private var rotateAnimation: Animation {
		Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
	}
	@State private var isAnimating = false
	public var body: some View {

		Icon(
			size: 25, icon: "loader-2",
			color: ColorProviderTool.def.buttonFront(colorScheme)
		)

		.rotationEffect(Angle(degrees: isAnimating ? 360 : -360))
		.animation(rotateAnimation, value: isAnimating)

		.onAppear {
			isAnimating = true
		}
	}
}

public struct LastIndication: View {

	public var body: some View {

		VerticalSpacer(size: 1)

	}
}
