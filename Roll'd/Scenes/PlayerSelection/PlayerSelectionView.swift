import SwiftUI

struct PlayerSelectionView: View {
    @State var playerName: String = ""
    @State var navigateToDareSelection: Bool = false

    var body: some View {
        RouletteWheelView() { name in
            guard name != "" else { return }
            playerName = name
            navigateToDareSelection = true
        }
            .navigationDestination(
                isPresented: $navigateToDareSelection
            ) {
                DareSelectionView(playerName: playerName)
            }
    }
}
#Preview {
    PlayerSelectionView()
}
