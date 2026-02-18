import SwiftUI

// MARK: - PrimaryButtonStyle

struct PrimaryButtonStyle: ButtonStyle {
    var gradient: LinearGradient = Theme.Gradient.primaryButton

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.buttonLarge)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(gradient, in: .capsule)
            .shadow(
                color: Theme.Accent.coral.opacity(0.4),
                radius: 12, y: 4
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Animations.snappy, value: configuration.isPressed)
    }
}

// MARK: - SecondaryButtonStyle

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.buttonLarge)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.Gradient.secondaryButton, in: .capsule)
            .shadow(
                color: Theme.Accent.electricBlue.opacity(0.3),
                radius: 12, y: 4
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Animations.snappy, value: configuration.isPressed)
    }
}

// MARK: - DangerButtonStyle

struct DangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.buttonLarge)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.Gradient.dangerButton, in: .capsule)
            .shadow(
                color: Theme.Accent.coral.opacity(0.3),
                radius: 12, y: 4
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Animations.snappy, value: configuration.isPressed)
    }
}

// MARK: - GhostButtonStyle

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.buttonMedium)
            .foregroundStyle(Theme.Accent.electricBlue)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Theme.Accent.electricBlue.opacity(configuration.isPressed ? 0.15 : 0.0),
                in: .capsule
            )
            .overlay(
                Capsule()
                    .strokeBorder(Theme.Accent.electricBlue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Animations.snappy, value: configuration.isPressed)
    }
}

// MARK: - PillButtonStyle

struct PillButtonStyle: ButtonStyle {
    var gradient: LinearGradient = Theme.Gradient.secondaryButton

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.buttonMedium)
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, Theme.Spacing.lg)
            .background(gradient, in: .capsule)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Animations.snappy, value: configuration.isPressed)
    }
}
