import SwiftUI

struct DareView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState
    @StateObject private var viewModel = DareViewModel()

    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()
            VStack(spacing: 30) {
                // Player's Name
                Text("\(appState.currentPlayer)'s Dare")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.black)
                
                // Dare Text
                Text(viewModel.selectedDare)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Colors.red.color)
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)

                Spacer()

                if !viewModel.isSpinning {
                    // Buttons
                    VStack(spacing: 20) {
                        // Challenge Complete Button
                        Button(action: didTapChallengeSucceeded) {
                            Text("Challenge Complete")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }

                        Button(action: didTapChallengeFailed) {
                            Text("Challenge Failed")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    Spacer()
                }
            }
            .padding()
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
    DareView()
}
