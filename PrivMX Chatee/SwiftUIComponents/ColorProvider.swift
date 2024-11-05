//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT Licence.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import SwiftUI

@MainActor
public class ColorProviderTool {
  public static var def: ColorProvider = DefaultColorProvider()
}

@MainActor
public protocol ColorProvider {
  func getColorHash(_ str: String?) -> Color
  func userColor(name: String) -> Color
  func frame(_ colorScheme: ColorScheme) -> Color
  func main(_ colorScheme: ColorScheme) -> Color
  func frontPrimary(_ colorScheme: ColorScheme) -> Color
  func frontSecondary(_ colorScheme: ColorScheme) -> Color
  func backgroundFull(_ colorScheme: ColorScheme) -> Color
  func backgroundLite(_ colorScheme: ColorScheme) -> Color
  func backgroundPrimary(_ colorScheme: ColorScheme) -> Color
  func backgroundSecondary(_ colorScheme: ColorScheme) -> Color
  func buttonFront(_ colorScheme: ColorScheme) -> Color
  func buttonBackgrouund(_ colorScheme: ColorScheme) -> Color
}

@MainActor
public class DefaultColorProvider: ColorProvider {

  public func getColorHash(_ str: String?) -> Color {
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

  public func userColor(name: String) -> Color {
    ColorProviderTool.def.getColorHash(name)
  }

  public func frame(_ colorScheme: ColorScheme) -> Color {
    ColorProviderTool.def.buttonBackgrouund(colorScheme).opacity(0.2)
  }

  public func main(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 39.0 / 255.0, green: 39.0 / 255.0, blue: 39.0 / 255.0)
    } else {
      Color(red: 69.0 / 255.0, green: 69.0 / 255.0, blue: 69.0 / 255.0)
    }
  }

  public func frontPrimary(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 206.0 / 255.0, green: 151.0 / 255.0, blue: 200.0 / 255.0)
    } else {
      Color(red: 56.0 / 255.0, green: 1.0 / 255.0, blue: 50.0 / 255.0)
    }
  }

  public func frontSecondary(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 156.0 / 255.0, green: 156.0 / 255.0, blue: 156.0 / 255.0)
    } else {
      Color(red: 106.0 / 255.0, green: 106.0 / 255.0, blue: 106.0 / 255.0)
    }
  }

  public func backgroundFull(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0)
    } else {
      Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
    }
  }

  public func backgroundLite(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 4.0 / 255.0, green: 4.0 / 255.0, blue: 4.0 / 255.0)
    } else {
      Color(red: 252.0 / 255.0, green: 252.0 / 255.0, blue: 252.0 / 255.0)
    }
  }

  public func backgroundPrimary(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0)
    } else {
      Color(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0)
    }
  }

  public func backgroundSecondary(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0)
    } else {
      Color(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0)
    }
  }

  public func buttonFront(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0)
    } else {
      Color(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0)
    }
  }

  public func buttonBackgrouund(_ colorScheme: ColorScheme) -> Color {
    if colorScheme == .dark {
      Color(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0)
    } else {
      Color(red: 59.0 / 255.0, green: 59.0 / 255.0, blue: 59.0 / 255.0)
    }
  }

}

extension Color {
  public init(hex: String) {
    let scanner = Scanner(string: hex)
    var rgb: UInt64 = 0
    if scanner.scanHexInt64(&rgb) {
      self.init(
        .sRGB,
        red: Double((rgb & 0xFF0000) >> 16) / 255.0,
        green: Double((rgb & 0x00FF00) >> 8) / 255.0,
        blue: Double(rgb & 0x0000FF) / 255.0,
        opacity: 1
      )
    } else {
      self.init(.red)
    }
  }

}
