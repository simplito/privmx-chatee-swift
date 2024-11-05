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

public struct HorizontalSpacer: View {
	var size: Double

	public init(size: Double) {
		self.size = size
	}

	public var body: some View {
		Rectangle().frame(width: size, height: 10).background(Color.clear).opacity(0)
	}
}
