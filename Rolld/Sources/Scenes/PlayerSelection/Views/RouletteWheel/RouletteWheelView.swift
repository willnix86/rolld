import SwiftUI

struct RouletteWheelView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var state: AppState

    @StateObject var viewModel = RouletteWheelViewModel()
    @State private var showWinnerOverlay = false

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: Theme.Spacing.lg) {
                if viewModel.availableNames.count >= 1 &&
                    state.previousPlayers.count < state.allPlayers.count {
                    RouletteWheel(
                        segmentCount: $viewModel.segmentCount,
                        items: $viewModel.availableNames,
                        colors: $viewModel.colors,
                        rotation: $viewModel.rotation,
                        size: 300,
                        spin: {
                            if viewModel.availableNames.count > 1 {
                                viewModel.spinRoulette()
                            } else {
                                guard let name = viewModel.availableNames.first else {
                                    return
                                }
                                viewModel.winningItem = name
                                showWinnerOverlay = true
                            }
                        },
                        onDragChanged: { viewModel.applyDragDelta($0) },
                        onDragEnded: { viewModel.startDecelerationSpin(angularVelocity: $0) }
                    )
                } else {
                    playAgainSection
                }

                playerInputSection
            }
            .onAppear {
                viewModel.onAppear(namesToExclude: state.previousPlayers)
                // TODO: Remove dummy names!
                if viewModel.availableNames.first(where: { $0 == "" }) != nil {
                    ["Henry", "John", "Mary", "James", "Robert",
                     "William", "Michael", "David", "Joseph", "Thomas"
                    ].forEach {
                        viewModel.newColorName = $0
                        viewModel.addNewItem()
                        state.addNewPlayer($0)
                    }
                }
            }
            .onDisappear {
                viewModel.invalidateTimer()
            }
            .onChange(of: viewModel.showAlert) { _, newValue in
                if newValue {
                    showWinnerOverlay = true
                    viewModel.showAlert = false
                }
            }

            // Winner overlay
            GameOverlay(isPresented: $showWinnerOverlay) {
                Text("\(viewModel.winningItem)")
                    .font(Typography.headingLarge)
                    .foregroundStyle(Theme.Text.primary)

                Text("Get ready to play!")
                    .font(Typography.bodyLarge)
                    .foregroundStyle(Theme.Text.secondary)

                Button("I'm ready!") {
                    showWinnerOverlay = false
                    state.setCurrentPlayer(viewModel.winningItem)
                    coordinator.push(.dare)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Subviews

    private var playAgainSection: some View {
        VStack {
            Spacer()
            Button("Play again!") {
                state.reset()
                viewModel.reset()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.xl)
            Spacer()
        }
        .frame(height: 300)
    }

    private var playerInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Enter name:")
                .font(Typography.headingSmall)
                .foregroundStyle(Theme.Text.secondary)
                .padding(.horizontal, Theme.Spacing.sm)
                .padding(.bottom, Theme.Spacing.sm)

            HStack(spacing: Theme.Spacing.sm) {
                StyledTextField(
                    placeholder: "Player name",
                    text: $viewModel.newColorName
                )

                Button("Add") {
                    viewModel.addNewItem()
                }
                .buttonStyle(
                    PillButtonStyle(gradient: Theme.Gradient.secondaryButton)
                )
            }
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.bottom, Theme.Spacing.lg)

            Text("Current players:")
                .font(Typography.headingSmall)
                .foregroundStyle(Theme.Text.secondary)
                .padding(.horizontal, Theme.Spacing.sm)
                .padding(.bottom, Theme.Spacing.sm)

            if !state.allPlayers.filter({ $0 != "" }).isEmpty {
                ScrollView {
                    LazyVStack(spacing: Theme.Spacing.sm) {
                        ForEach(
                            Array(state.allPlayers.enumerated()),
                            id: \.offset
                        ) { index, name in
                            HStack {
                                Text(name)
                                    .font(Typography.bodyLarge)
                                    .foregroundStyle(Theme.Text.primary)

                                Spacer()

                                Button {
                                    let indexSet = IndexSet(integer: index)
                                    viewModel.deleteItems(at: indexSet)
                                    state.deletePlayers(at: indexSet)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Theme.Text.tertiary)
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.sm)
                            .background(
                                Theme.Background.surface,
                                in: .rect(cornerRadius: Theme.Radius.md)
                            )
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.sm)
                }
            }
        }
    }
}

#Preview {
    var coordinator = NavigationCoordinator(initialScreen: .playerSelection)
    var state = AppState()

    RouletteWheelView()
        .environment(coordinator)
        .environment(state)
}
