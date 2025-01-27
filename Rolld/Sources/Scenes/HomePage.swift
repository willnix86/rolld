import SwiftUI

struct HomePage: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    
    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()

            VStack {
                Text("Welcome to Dice Game")
                    .foregroundStyle(.black)
                    .font(.largeTitle)
                    .padding()

                Button(
                    "Play",
                    action: {
                        coordinator.push(.playerSelection)
                    }
                )
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

        }
        .navigationBarHidden(true)
    }
}
