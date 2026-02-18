import SwiftUI

// MARK: - Theme

enum Theme {

    // MARK: Background

    enum Background {
        static let primary = Color(hex: "#1A1B2E")
        static let secondary = Color(hex: "#242640")
        static let surface = Color(hex: "#2D2F4E")
        static let elevated = Color(hex: "#363863")
    }

    // MARK: Accent

    enum Accent {
        static let coral = Color(hex: "#FF6B6B")
        static let electricBlue = Color(hex: "#4ECDC4")
        static let amber = Color(hex: "#FFD93D")
        static let violet = Color(hex: "#A78BFA")
        static let hotPink = Color(hex: "#FF69B4")
        static let lime = Color(hex: "#A3E635")
    }

    // MARK: Text

    enum Text {
        static let primary = Color.white
        static let secondary = Color.white.opacity(0.7)
        static let tertiary = Color.white.opacity(0.45)
    }

    // MARK: Gradients

    enum Gradient {
        static let primaryButton = LinearGradient(
            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF8E53")],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let secondaryButton = LinearGradient(
            colors: [Color(hex: "#4ECDC4"), Color(hex: "#3BA99C")],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let dangerButton = LinearGradient(
            colors: [Color(hex: "#FF6B6B"), Color(hex: "#E84545")],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let backgroundGlow = RadialGradient(
            colors: [
                Color(hex: "#A78BFA").opacity(0.15),
                Color.clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 300
        )
    }

    // MARK: Wheel Colors

    static let wheelColors: [Color] = [
        Accent.coral,
        Accent.electricBlue,
        Accent.amber,
        Accent.violet,
        Accent.hotPink,
        Accent.lime,
        Color(hex: "#FF8E53"),   // orange
        Color(hex: "#3BA99C"),   // dark teal
        Color(hex: "#C084FC"),   // light violet
        Color(hex: "#FBBF24"),   // gold
    ]

    // MARK: Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: Radius

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let pill: CGFloat = 100
    }

    // MARK: UIColors (for SpriteKit)

    enum UIColors {
        static let background = UIColor(hex: "#1A1B2E")
        static let coral = UIColor(hex: "#FF6B6B")
        static let amber = UIColor(hex: "#FFD93D")
    }
}
