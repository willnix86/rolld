import SwiftUI

struct DareResultView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator

    let playerName: String
    let dareText: String

    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Spacer()
                
                // Player's Name
                Text("\(playerName)'s Dare")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.primary)
                
                // Dare Text
                Text(dareText)
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 20) {
                    // Challenge Complete Button
                    Button(action: completeChallenge) {
                        Text("Challenge Complete")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    // Challenge Failed Button
                    //                NavigationLink(
                    //                    destination: ForfeitView(playerName: playerName),
                    //                    isActive: $navigateToForfeit
                    //                ) {
                    Button(action: failChallenge) {
                        Text("Challenge Failed")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    //                }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }

    private func completeChallenge() {
        coordinator.popTo(.playerSelection)
    }

    private func failChallenge() {
        // Navigate to the Forfeit Screen
    }
}

#Preview {
    DareResultView(
        playerName: "Will",
        dareText: "Dance the macarena"
    )
}
