import SwiftUI
import SpriteKit

struct DiceView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState

    @State private var selectedForfeit = ""
    @State private var showForfeitOverlay = false
    @State private var diceScene: DiceScene?

    var forfeits: [String]

    var body: some View {
        ZStack {
            if let diceScene {
                SpriteView(scene: diceScene)
            } else {
                Theme.Background.primary
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
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {
            guard diceScene == nil else { return }
            let scene = DiceScene(
                size: UIScreen.main.bounds.size,
                playerName: appState.currentPlayer,
                items: forfeits
            ) { item in
                selectedForfeit = item
                showForfeitOverlay = true
            }
            scene.scaleMode = .resizeFill
            diceScene = scene
        }
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
