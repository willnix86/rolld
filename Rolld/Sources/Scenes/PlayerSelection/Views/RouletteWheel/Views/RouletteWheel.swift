import SwiftUI

struct RouletteWheel: View {
    @Binding var segmentCount: Int
    @Binding var items: [String]
    @Binding var colors: [Color]
    @Binding var rotation: Double
    @State var radius: CGFloat = 0

    var size: CGFloat
    var spin: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<segmentCount, id: \.self) { index in
                    ZStack {
                        Segment(
                            startAngle: angleForSegment(index),
                            endAngle: angleForSegment(index + 1)
                        )
                        .foregroundStyle(colors[index % colors.count])
                        .onAppear {
                            let midX = geo.frame(in: .local).midX + 40
                            let midY = geo.frame(in: .local).midY + 40
                            radius = min(midX, midY)
                        }

                        Text(items[index])
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
                    .rotationEffect(.degrees(rotation))
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
                spin()
            }
        }
        .frame(width: size, height: size)
    }

    func angleForSegment(_ index: Int) -> Angle {
        Angle(degrees: Double(index) / Double(items.count) * 360)
    }

    func textAngleForSegment(_ index: Int) -> Angle {
        let segmentAngle = 360.0 / Double(items.count)
        return Angle(degrees: -Double(index) * segmentAngle - segmentAngle / 2)
    }
}

#Preview {
    @Previewable @State var segmentCount = 5
    @Previewable @State var items: [String] = ["Abbie", "Bob", "Charlie", "David", "Eve"]
    @Previewable @State var colors: [Color] = [.blue, .red, .green, .yellow, .orange]
    @Previewable @State var rotation: Double = 0

    ZStack {
        Color.green.ignoresSafeArea()
        VStack {
            RouletteWheel(
                segmentCount: $segmentCount,
                items: $items,
                colors: $colors,
                rotation: $rotation,
                radius: 100,
                size: 300,
                spin: {}
            )

            Text("Hello")
        }
    }
}
