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

extension Color {

	static func getColorHash(_ str: String?) -> Color {
		let colorsMantine: [String] = [
			"E75F59",
			"D45580",
			"B052D4",
			"7352E9",
			"536DED",
			"4487DC",
			"4EA5BA",
			"64B961",
			"92C744",
			"EFB33F",
			"ED8537",

		]

		guard let str = str else { return Color(hex: colorsMantine[0]) }

		var hash: Int = 0
		for char in str.utf16 {
			hash = (hash << 5) &- hash &+ Int(char)
		}

		let index = abs(hash) % colorsMantine.count
		return Color(hex: colorsMantine[index])
	}

	static func userColor(name: String) -> Color {
		Color.getColorHash(name)
	}

	static func frame(_ colorScheme: ColorScheme) -> Color {
		Color.buttonBackground(colorScheme).opacity(0.2)
	}

	static func chateeMain(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 39.0 / 255.0, green: 39.0 / 255.0, blue: 39.0 / 255.0)
		} else {
			Color(red: 69.0 / 255.0, green: 69.0 / 255.0, blue: 69.0 / 255.0)
		}
	}
	static func frontPrimary(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 206.0 / 255.0, green: 151.0 / 255.0, blue: 200.0 / 255.0)
		} else {
			Color(red: 56.0 / 255.0, green: 1.0 / 255.0, blue: 50.0 / 255.0)
		}
	}
	static func frontSecondary(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 156.0 / 255.0, green: 156.0 / 255.0, blue: 156.0 / 255.0)
		} else {
			Color(red: 106.0 / 255.0, green: 106.0 / 255.0, blue: 106.0 / 255.0)
		}
	}
	static func backgroundFull(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0)
		} else {
			Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
		}
	}
	static func backgroundLite(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 4.0 / 255.0, green: 4.0 / 255.0, blue: 4.0 / 255.0)
		} else {
			Color(red: 252.0 / 255.0, green: 252.0 / 255.0, blue: 252.0 / 255.0)
		}
	}

	static func backgroundPrimary(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0)
		} else {
			Color(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0)
		}
	}

	static func backgroundSecondary(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0)
		} else {
			Color(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0)
		}
	}

	static func buttonFront(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0)
		} else {
			Color(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0)
		}
	}
	static func buttonBackground(_ colorScheme: ColorScheme) -> Color {
		if colorScheme == .dark {
			Color(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0)
		} else {
			Color(red: 59.0 / 255.0, green: 59.0 / 255.0, blue: 59.0 / 255.0)
		}
	}

}
