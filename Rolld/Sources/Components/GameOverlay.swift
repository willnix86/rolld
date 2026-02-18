import SwiftUI

struct GameOverlay<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {} // Prevent taps passing through

                VStack(spacing: Theme.Spacing.lg) {
                    content()
                }
                .padding(Theme.Spacing.xl)
                .frame(maxWidth: 320)
                .background(.ultraThinMaterial)
                .background(Theme.Background.elevated)
                .clipShape(.rect(cornerRadius: Theme.Radius.xl))
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                .transition(
                    .scale(scale: 0.8)
                    .combined(with: .opacity)
                )
            }
            .animation(Animations.bouncy, value: isPresented)
        }
    }
}
