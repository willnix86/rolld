import SwiftUI

struct GameCard: View {
    let text: String
    var isAnimating: Bool = false
    var index: Int? = nil

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            if let index {
                let circleColor = Theme.wheelColors[index % Theme.wheelColors.count]
                Text("\(index + 1)")
                    .font(Typography.cardTitle)
                    .foregroundStyle(circleColor.contrastingTextColor)
                    .frame(width: 32, height: 32)
                    .background(circleColor, in: Circle())
            }

            Text(text)
                .font(Typography.cardBody)
                .foregroundStyle(Theme.Text.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Theme.Background.elevated)
        .clipShape(.rect(cornerRadius: Theme.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .strokeBorder(
                    isAnimating ? Theme.Accent.amber.opacity(0.6) : Theme.Accent.violet.opacity(0.2),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
    }
}
