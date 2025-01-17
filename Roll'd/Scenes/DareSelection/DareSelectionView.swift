import SwiftUI

struct DareSelectionView: View {
    @StateObject private var viewModel = DareSelectionViewModel()

    let playerName: String

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ForEach(0..<6, id: \.self) { index in
                Text(viewModel.selectedDares[index])
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            HStack {
                Button(action: viewModel.rollTheDice) {
                    Text("Roll the dice")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .opacity(
                    viewModel.isSpinning ? 0.5 : 1
                )
                .disabled(viewModel.isSpinning)

                Button(action: viewModel.spinAgain) {
                    Text("Spin Again")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .opacity(
                    viewModel.isSpinning || viewModel.hasSpunAgain ? 0.5 : 1
                )
                .disabled(viewModel.isSpinning || viewModel.hasSpunAgain)
            }

            .padding(.bottom)
        }
        .padding()
        .animation(.easeInOut, value: viewModel.selectedDares)
        .onAppear {
            viewModel.onAppear()
        }
        .navigationDestination(
            isPresented: $viewModel.navigateToDiceView
        ) {
            DiceView(
                playerName: playerName,
                dares: viewModel.selectedDares
            )
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    DareSelectionView(playerName: "Will")
}
