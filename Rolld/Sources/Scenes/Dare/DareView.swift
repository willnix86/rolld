import SwiftUI

struct DareView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState
    @StateObject private var viewModel = DareViewModel()

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: Theme.Spacing.lg) {
                // Player's Name
                Text("\(appState.currentPlayer)'s Dare")
                    .font(Typography.headingLarge)
                    .foregroundStyle(Theme.Text.primary)
                    .padding(.top, Theme.Spacing.xl)

                Spacer()

                // Dare Card
                GameCard(
                    text: viewModel.selectedDare,
                    isAnimating: viewModel.isSpinning
                )
                .scaleEffect(viewModel.shuffleScale)
                .animation(Animations.snappy, value: viewModel.shuffleScale)
                .padding(.horizontal, Theme.Spacing.md)

                Spacer()

                // Buttons
                if !viewModel.isSpinning {
                    VStack(spacing: Theme.Spacing.md) {
                        Button("Dare Complete") {
                            didTapChallengeSucceeded()
                        }
                        .buttonStyle(
                            PrimaryButtonStyle(gradient: LinearGradient(
                                colors: [Theme.Accent.lime, Color(hex: "#65A30D")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                        )

                        Button("Dare Failed") {
                            didTapChallengeFailed()
                        }
                        .buttonStyle(DangerButtonStyle())
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
                } else {
                    Spacer()
                        .frame(height: 150)
                }

                Spacer()
                    .frame(height: Theme.Spacing.lg)
            }
            .padding()
            .animation(Animations.bouncy, value: viewModel.isSpinning)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarHidden(true)
    }

    private func didTapChallengeSucceeded() {
        guard !appState.currentPlayer.isEmpty else {
            return
        }
        appState.addToPreviousPlayers(appState.currentPlayer)
        coordinator.popTo(.playerSelection)
    }

    private func didTapChallengeFailed() {
        coordinator.push(.forfeitSelection)
    }
}

#Preview {
    var coordinator = NavigationCoordinator(initialScreen: .dare)
    var state = AppState()

    DareView()
        .environment(coordinator)
        .environment(state)
}
