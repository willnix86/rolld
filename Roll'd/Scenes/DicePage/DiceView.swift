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
        }
    }

    func getDiceScene(size: CGSize) -> SKScene {
        let scene = DiceScene(
            size: size
        )
        scene.scaleMode = .aspectFit

        return scene
    }
}
