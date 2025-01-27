import SwiftUI

struct RouletteWheelView: View {
    @Environment(NavigationCoordinator.self) var coordinator: NavigationCoordinator
    @Environment(AppState.self) var state: AppState
    
    @StateObject var viewModel = RouletteWheelViewModel()

    var body: some View {
        ZStack {
            Colors.orange.color
                .ignoresSafeArea()
            VStack(spacing: 30) {
                RouletteWheel(
                    segmentCount: $viewModel.segmentCount,
                    items: $viewModel.names,
                    colors: $viewModel.colors,
                    rotation: $viewModel.rotation,
                    size: 300
                ) {
                    viewModel.spinRoulette()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Enter name:")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)

                    HStack {
                        TextField(
                            "",
                            text: $viewModel.newColorName
                        )
                            .padding(.leading).frame(height: 55)
                            .background(
                                .white.opacity(0.5),
                                in: .rect(cornerRadius: 12)
                            )
                            .foregroundStyle(.black)

                        Button(action: {
                            viewModel.addNewItem()
                        }, label: {
                            Text("Add").bold()
                                .frame(width: 80, height: 55)
                                .background(
                                    .green,
                                    in: .rect(cornerRadius: 12)
                                )
                        })
                        .tint(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)

                    Text("Current players:")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)

                    if viewModel.names.filter({ $0 != ""}).isEmpty == false {
                        List {
                            ForEach(viewModel.names, id: \.self) { name in
                                Text(name)
                                    .listRowBackground(
                                        Color.white.opacity(0.5)
                                    )
                                    .foregroundStyle(.black)
                            }
                            .onDelete(perform: viewModel.deleteItems)
                        }
                        .listStyle(.plain)
                    }
                }
                .alert(
                    "",
                    isPresented: $viewModel.showAlert,
                    actions: {
                        Button("I'm ready!") {
                            state.setCurrentPlayer(viewModel.winningItem)
                            coordinator.push(.dare)
                        }
                    },
                    message: {
                        Text("\(viewModel.winningItem) get ready to play!")
                    }
                )
            }
            .onAppear {
                viewModel.onAppear()
                // TODO: Remove dummy names!
                if viewModel.names.first(where: { $0 ==
                    "" }) != nil {
                    ["Henry", "John", "Mary", "James", "Robert", "William", "Michael", "David", "Joseph", "Thomas"].forEach {
                        viewModel.newColorName = $0
                        viewModel.addNewItem()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    var coordinator = NavigationCoordinator(initialScreen: .playerSelection)
    var state = AppState()

    RouletteWheelView()
        .environment(coordinator)
        .environment(state)
}
