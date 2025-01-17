import SwiftUI

struct RouletteWheelView: View {
    @State var radius: CGFloat = 0
    @StateObject var vm = RouletteWheelViewModel()

    var navigateToNextPage: (String) -> Void

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<vm.segmentCount, id: \.self) { index in
                        ZStack {
                            Segment(
                                startAngle: angleForSegment(index),
                                endAngle: angleForSegment(index + 1)
                            )
                            .foregroundStyle(vm.colors[index % vm.colors.count])
                            .onAppear {
                                let midX = geo.frame(in: .local).midX + 40
                                let midY = geo.frame(in: .local).midY + 40
                                radius = min(midX, midY)
                            }

                            Text(vm.names[index])
                                .foregroundStyle(.white)
                                .font(.headline)
                                .rotationEffect(angleForSegment(index + 1) - Angle(degrees: 10))
                                .offset(
                                    CGSize(
                                        width: { () -> Double in
                                            let mean: Angle = (
                                                angleForSegment(index) + angleForSegment(index + 1)
                                            ) / 2

                                            return radius * 0.5 * cos(mean.radians)
                                        }(),
                                        height: { () -> Double in
                                            let mean: Angle = (
                                                angleForSegment(index) + angleForSegment(index + 1)
                                            ) / 2

                                            return radius * 0.5 * sin(mean.radians)
                                        }()
                                    )
                                )
                        }
                        .frame(width: 300, height: 300)
                        .rotationEffect(.degrees(vm.rotation))
                    }
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)

                    Arrow()
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(180))
                        .offset(x: 150)
                        .shadow(color: .gray, radius: 42, x: 2, y: 2)
                }
                .onTapGesture { // Change to swipe
                    vm.spinRoulette()
                }
            }
            .frame(width: 300)

            VStack(spacing: 10) {
                HStack {
                    TextField("Enter name", text: $vm.newColorName)
                        .padding(.leading).frame(height: 55)
                        .background(.thinMaterial, in: .rect(cornerRadius: 12))
                    Button(action: {
                        vm.addNewItem()
                    }, label: {
                        Text("Add").bold()
                            .frame(width: 80, height: 55)
                            .background(.thinMaterial, in: .rect(cornerRadius: 12))
                    })
                    .tint(.primary)
                }
                Spacer()
                if vm.names.filter({ $0 != ""}).isEmpty == false {
                    List {
                        ForEach(vm.names, id: \.self) { name in
                            Text(name)
                        }
                        .onDelete(perform: vm.deleteItems)
                    }
                    .listStyle(.grouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal, 10)
            .alert(
                "",
                isPresented: $vm.showAlert,
                actions: {
                    Button("I'm ready!") {
                        navigateToNextPage(vm.winningItem)
                    }
                },
                message: {
                    Text("\(vm.winningItem) get ready to play!")
                }
            )
        }
//        .onAppear {
//            // TODO: Remove dummy names!
//            ["Henry", "John", "Mary", "James", "Robert", "William", "Michael", "David", "Joseph", "Thomas"].forEach {
//                vm.newColorName = $0
//                vm.addNewItem()
//            }
//        }
    }

    func angleForSegment(_ index: Int) -> Angle {
        Angle(degrees: Double(index) / Double(vm.names.count) * 360)
    }

    func textAngleForSegment(_ index: Int) -> Angle {
        let segmentAngle = 360.0 / Double(vm.names.count)
        return Angle(degrees: -Double(index) * segmentAngle - segmentAngle / 2)
    }
}

#Preview {
    RouletteWheelView() { _ in }
}
