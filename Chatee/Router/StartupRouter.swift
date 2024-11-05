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

final class StartupRouter: ObservableObject {

	public enum Destination: Codable, Hashable {
		case login
		case createAccount
		case networkUnreachable
	}

	@Published var navPath = NavigationPath()

	func navigate(to destination: Destination) {
		navPath.append(destination)
	}

	func navigateBack() {
		navPath.removeLast()
	}

	func navigateToRoot() {
		navPath.removeLast(navPath.count)
	}
}
