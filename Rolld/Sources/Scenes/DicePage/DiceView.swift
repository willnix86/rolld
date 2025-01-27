import SwiftUI
import SpriteKit

struct DiceView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var appState: AppState

    @State var selectedForfeit = ""
    @State var showForfeitAlert = false

    var forfeits: [String]

    var body: some View {
        GeometryReader { proxy in
            VStack {
                SpriteView(
                    scene: getScene(size: proxy.size)
                )
            }
            .alert(
                "",
                isPresented: $showForfeitAlert,
                actions: {
                    Button("Challenge accepted") {
                        guard !appState.currentPlayer.isEmpty else {
                            return
                        }

                        appState.addToPreviousPlayers(appState.currentPlayer)
                        coordinator.popTo(.playerSelection)
                    }
                },
                message: {
                    Text(selectedForfeit)
                }
            )

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
            showForfeitAlert = true
        }
        scene.scaleMode = .aspectFit

        return scene
    }
}

#Preview {
    DiceView(
        forfeits: [
            "Do the dishes",
            "Feed the pets",
            "Take out the trash",
            "Mow the lawn",
            "Vacuum the floors",
            "Wipe down kitchen counters"
        ]
    )
}
