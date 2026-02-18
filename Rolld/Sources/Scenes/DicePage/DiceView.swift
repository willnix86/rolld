import SwiftUI
import SpriteKit

struct DiceView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState

    @State var selectedForfeit = ""
    @State var showForfeitOverlay = false

    var forfeits: [String]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    SpriteView(
                        scene: getScene(size: proxy.size)
                    )
                }

                // Dice result overlay
                GameOverlay(isPresented: $showForfeitOverlay) {
                    Text("Your Forfeit")
                        .font(Typography.headingMedium)
                        .foregroundStyle(Theme.Text.secondary)

                    Text(selectedForfeit)
                        .font(Typography.bodyLarge)
                        .foregroundStyle(Theme.Text.primary)
                        .multilineTextAlignment(.center)

                    Button("Let's go!") {
                        guard !appState.currentPlayer.isEmpty else {
                            return
                        }
                        appState.addToPreviousPlayers(appState.currentPlayer)
                        coordinator.popTo(.playerSelection)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }

    private func getScene(size: CGSize) -> SKScene {
        let scene = DiceScene(
            size: size,
            playerName: appState.currentPlayer,
            items: forfeits
        ) { item in
            selectedForfeit = item
            showForfeitOverlay = true
        }
        scene.scaleMode = .aspectFit

        return scene
    }
}

#Preview {
    let forfeits = [
        "Do the dishes",
        "Feed the pets",
        "Take out the trash",
        "Mow the lawn",
        "Vacuum the floors",
        "Wipe down kitchen counters"
    ]

    var coordinator = NavigationCoordinator(initialScreen: .dice(forfeits: forfeits))
    var state = AppState()

    DiceView(forfeits: forfeits)
    .environment(coordinator)
    .environment(state)
}
