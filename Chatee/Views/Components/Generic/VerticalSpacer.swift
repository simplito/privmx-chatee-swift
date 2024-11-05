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

public struct VerticalSpacer: View {
	var size: Double

	public init(size: Double) {
		self.size = size
	}

	public var body: some View {
		Rectangle().frame(width: 10, height: size).background(Color.clear).opacity(0)
	}
}
