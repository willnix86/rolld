import SwiftUI
import SpriteKit

struct DiceView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator

    @State var selectedDare = ""
    @State var showDareAlert = false

    var playerName: String
    var dares: [String]

    var body: some View {
        GeometryReader { proxy in
            VStack {
                SpriteView(
                    scene: getScene(size: proxy.size)
                )
            }
            .alert(
                "",
                isPresented: $showDareAlert,
                actions: {
                    Button("Challenge accepted") {
                        coordinator.push(.dareResult(playerName: playerName, dare: selectedDare))
                    }
                },
                message: {
                    Text(selectedDare)
                }
            )

        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }

    private func getScene(size: CGSize) -> SKScene {
        let scene = DiceScene(
            size: size,
            playerName: playerName,
            dares: dares
        ) { dare in
            selectedDare = dare
            showDareAlert = true
        }
        scene.scaleMode = .aspectFit

        return scene
    }
}

#Preview {
    DiceView(
        playerName: "Will",
        dares: [
            "Do the dishes",
            "Feed the pets",
            "Take out the trash",
            "Mow the lawn",
            "Vacuum the floors",
            "Wipe down kitchen counters"
        ]
    )
}
