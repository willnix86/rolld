import SwiftUI

struct GameBackground: View {
    var body: some View {
        ZStack {
            Theme.Background.primary
                .ignoresSafeArea()

            Theme.Gradient.backgroundGlow
                .ignoresSafeArea()
        }
    }
}
