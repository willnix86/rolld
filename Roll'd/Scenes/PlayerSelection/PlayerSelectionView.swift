import SwiftUI

struct PlayerSelectionView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator

    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()
            
            RouletteWheelView() { name in
                guard name != "" else { return }
                coordinator.push(.dareSelection(playerName: name))
            }
        }
        .navigationBarHidden(true)
    }
}
#Preview {
    PlayerSelectionView()
}
