import SwiftUI
import SpriteKit

struct DiceView: View {
    var playerName: String

    var body: some View {
        GeometryReader { proxy in
            VStack {
                SpriteView(
                    scene: getScene(size: proxy.size)
                )
            }
        }.ignoresSafeArea(.all)
    }

    func getScene(size: CGSize) -> SKScene {
        let scene = DiceScene(
            size: size,
            playerName: playerName
        )
        scene.scaleMode = .aspectFit

        return scene
    }
}
