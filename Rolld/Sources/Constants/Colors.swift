import SwiftUI

enum Colors: String {
    case white = "#FFFFFF"
    case black = "#000000"
    case lightGray = "#D8D8D8"
    case red = "#FB4525"
    case orange = "#F2C73D"

    var color: Color {
        Color(hex: rawValue)
    }

    var uiColor: UIColor {
        UIColor(hex: rawValue)
    }
}
