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

public struct PasswordInfo<Row>: View where Row: View {
	@Binding var isOk: Bool?

	@ViewBuilder var row: () -> Row

	public init(isOk: Binding<Bool?>, row: @escaping () -> Row) {
		self._isOk = isOk
		self.row = row
	}

	public var body: some View {
		HStack {
			if let isOk = isOk {
				if isOk {
					Image(systemName: "checkmark").foregroundColor(.green)
					row().foregroundColor(.green)
				} else {
					Image(systemName: "xmark").foregroundColor(.red)
					row().foregroundColor(.red)
				}
			} else {
				Image(systemName: "xmark").foregroundColor(.black.opacity(0.2))
				row().foregroundColor(.black.opacity(0.2))
			}
			Spacer()
		}
	}

}
