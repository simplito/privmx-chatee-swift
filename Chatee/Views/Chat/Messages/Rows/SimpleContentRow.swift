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
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import SwiftUI

struct SimpleContentRow: View {

	@EnvironmentObject var messagesList: ThreadModel
	@State var content: String

	var body: some View {

		HStack(spacing: 0) {

			VStack {

			}.frame(width: 60, height: 25)

			VStack(spacing: 0) {
				HStack {

					Text(String(content))

					Spacer()
				}
			}.padding(.trailing, 30)
		}

	}
}
