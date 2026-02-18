import SwiftUI

enum Typography {

    // MARK: Display

    static let displayLarge = Font.system(size: 40, weight: .heavy, design: .rounded)
    static let displayMedium = Font.system(size: 34, weight: .bold, design: .rounded)

    // MARK: Heading

    static let headingLarge = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headingMedium = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headingSmall = Font.system(size: 18, weight: .bold, design: .rounded)

    // MARK: Body

    static let bodyLarge = Font.system(size: 17, weight: .medium, design: .rounded)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .rounded)
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .rounded)

    // MARK: Button

    static let buttonLarge = Font.system(size: 18, weight: .bold, design: .rounded)
    static let buttonMedium = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let buttonSmall = Font.system(size: 14, weight: .semibold, design: .rounded)

    // MARK: Card

    static let cardTitle = Font.system(size: 16, weight: .bold, design: .rounded)
    static let cardBody = Font.system(size: 15, weight: .medium, design: .rounded)
}
