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

extension View {

	func focusablePadding(_ edges: Edge.Set = .all, _ size: CGFloat? = nil) -> some View {
		modifier(FocusablePadding(edges, size))
	}

}

private struct FocusablePadding: ViewModifier {

	private let edges: Edge.Set
	private let size: CGFloat?
	@FocusState private var focused: Bool

	init(_ edges: Edge.Set, _ size: CGFloat?) {
		self.edges = edges
		self.size = size
		self.focused = false
	}

	func body(content: Content) -> some View {
		content
			.focused($focused)
			.padding(edges, size)
			.contentShape(Rectangle())
			.onTapGesture { focused = true }
	}

}
