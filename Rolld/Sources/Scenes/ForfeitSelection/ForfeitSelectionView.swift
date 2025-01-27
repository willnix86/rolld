import SwiftUI

struct ForfeitSelectionView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState
    
    @StateObject private var viewModel = ForfeitSelectionViewModel()

    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Forfeit")
                    .foregroundStyle(.black)

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
                    }
                }
                
                Spacer()

                if !viewModel.isSpinning {

                    Text("Choose a forfeit or let the dice choose for you!")
                        .foregroundStyle(.black)

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
                            viewModel.isSpinning || viewModel.hasSpunAgain ? 0.5 : 1
                        )
                        .disabled(viewModel.isSpinning || viewModel.hasSpunAgain)

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
                    .padding(.bottom)
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
        coordinator.popTo(
            .dice(forfeits: viewModel.selectedForfeits)
        )
    }
}

#Preview {
    ForfeitSelectionView()
}
