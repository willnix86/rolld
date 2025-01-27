import SwiftUI

struct ForfeitSelectionView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState
    
    @StateObject private var viewModel = ForfeitSelectionViewModel()

    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()
            
            VStack {
                Text("Choose a forfeit or let the dice choose for you!")
                    .foregroundStyle(.black)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                ForEach(0..<6, id: \.self) { index in
                    Button(action: didTapForfeit) {
                        Text(viewModel.selectedForfeits[index])
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .background(Colors.red.color)
                            .cornerRadius(10)
                            .multilineTextAlignment(.leading)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )

                    }
                }

                Spacer()

                    HStack {
                        Button(action: didTapRollTheDice) {
                            Text("Roll the Dice")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .opacity(
                            viewModel.isSpinning ? 0.5 : 1
                        )
                        .disabled(viewModel.isSpinning)

                        Button(action: viewModel.didTapSpinAgain) {
                            Text("Spin Again")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .opacity(
                            viewModel.isSpinning || viewModel.hasSpunAgain ? 0.5 : 1
                        )
                        .disabled(viewModel.isSpinning || viewModel.hasSpunAgain)
                    }

            }
            .padding()
            .animation(.easeInOut, value: viewModel.selectedForfeits)
            .onAppear {
                viewModel.onAppear(
                    playerName: appState.currentPlayer
                )
            }
            .navigationBarHidden(true)
        }
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
