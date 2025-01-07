import SwiftUI
import SpriteKit

struct DiceView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                SpriteView(
                    scene: getDiceScene(size: proxy.size)
                )
            }
        }.ignoresSafeArea(.all)
    }

    func getDiceScene(size: CGSize) -> SKScene {
        let scene = DiceScene(
            size: size,
            playerName: "Will"
        )
        scene.scaleMode = .aspectFit

        return scene
    }
}
