import SwiftUI

struct HomePage: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator

    @State private var titleScale: CGFloat = 0.8
    @State private var subtitleOpacity: CGFloat = 0
    @State private var buttonOffset: CGFloat = 40
    @State private var buttonOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()

                Text("ROLL'D")
                    .font(Typography.displayLarge)
                    .foregroundStyle(Theme.Text.primary)
                    .shadow(color: Theme.Accent.coral.opacity(0.6), radius: 20)
                    .scaleEffect(titleScale)

                Text("The Party Dare Game")
                    .font(Typography.headingMedium)
                    .foregroundStyle(Theme.Text.secondary)
                    .opacity(subtitleOpacity)

                Spacer()

                Button("Let's Play") {
                    coordinator.push(.playerSelection)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, Theme.Spacing.xl)
                .offset(y: buttonOffset)
                .opacity(buttonOpacity)

                Spacer()
                    .frame(height: Theme.Spacing.xxl)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(Animations.bouncy) {
                titleScale = 1.0
            }
            withAnimation(Animations.gentle.delay(0.3)) {
                subtitleOpacity = 1.0
            }
            withAnimation(Animations.bouncy.delay(0.5)) {
                buttonOffset = 0
                buttonOpacity = 1.0
            }
        }
    }
}

#Preview {
    var coordinator = NavigationCoordinator(initialScreen: .home)
    var state = AppState()

    HomePage()
        .environment(coordinator)
        .environment(state)
}
