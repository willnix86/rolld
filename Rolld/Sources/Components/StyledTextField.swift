import SwiftUI

struct StyledTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .font(Typography.bodyLarge)
            .foregroundStyle(Theme.Text.primary)
            .padding(.horizontal, Theme.Spacing.md)
            .frame(height: 55)
            .background(Theme.Background.surface, in: .rect(cornerRadius: Theme.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .strokeBorder(Theme.Accent.electricBlue.opacity(0.4), lineWidth: 1)
            )
    }
}
