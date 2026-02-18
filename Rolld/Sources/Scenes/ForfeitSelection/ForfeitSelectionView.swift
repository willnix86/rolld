import SwiftUI

struct ForfeitSelectionView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState

    @StateObject private var viewModel = ForfeitSelectionViewModel()

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: Theme.Spacing.md) {
                Text("Choose Your Fate")
                    .font(Typography.headingLarge)
                    .foregroundStyle(Theme.Text.primary)
                    .padding(.top, Theme.Spacing.lg)

                Text("Pick a forfeit or let the dice decide!")
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.Text.secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                // Forfeit cards
                ForEach(0..<6, id: \.self) { index in
                    GameCard(
                        text: viewModel.selectedForfeits[index],
                        isAnimating: viewModel.isSpinning && !viewModel.lockedIndices.contains(index),
                        index: index
                    )
                    .scaleEffect(viewModel.cardScales[index])
                    .animation(Animations.snappy, value: viewModel.cardScales[index])
                    .transition(
                        .scale.combined(with: .opacity)
                    )
                    .animation(
                        Animations.stagger(index: index),
                        value: viewModel.selectedForfeits[index]
                    )
                    .onTapGesture {
                        guard !viewModel.isSpinning else { return }
                        didTapForfeit()
                    }
                }

                Spacer()

                // Action buttons
                HStack(spacing: Theme.Spacing.md) {
                    Button("Roll the Dice") {
                        didTapRollTheDice()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .opacity(viewModel.isSpinning ? 0.5 : 1)
                    .disabled(viewModel.isSpinning)

                    Button("Spin Again") {
                        viewModel.didTapSpinAgain()
                    }
                    .buttonStyle(GhostButtonStyle())
                    .opacity(
                        viewModel.isSpinning || viewModel.hasSpunAgain ? 0.5 : 1
                    )
                    .disabled(viewModel.isSpinning || viewModel.hasSpunAgain)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.lg)
            }
            .padding(.horizontal, Theme.Spacing.md)
        }
        .onAppear {
            viewModel.onAppear(
                playerName: appState.currentPlayer
            )
        }
        .navigationBarHidden(true)
    }

    private func didTapForfeit() {
        guard !appState.currentPlayer.isEmpty else {
            return
        }
        appState.addToPreviousPlayers(appState.currentPlayer)
        coordinator.popTo(.playerSelection)
    }

    private func didTapRollTheDice() {
        coordinator.push(
            .dice(forfeits: viewModel.selectedForfeits)
        )
    }
}

#Preview {
    var coordinator = NavigationCoordinator(initialScreen: .forfeitSelection)
    var state = AppState()

    ForfeitSelectionView()
        .environment(coordinator)
        .environment(state)
}
