import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Dice Game")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(
                    destination: PlayerSelectionView().navigationBarBackButtonHidden()
                ) {
                    Text("Play")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
