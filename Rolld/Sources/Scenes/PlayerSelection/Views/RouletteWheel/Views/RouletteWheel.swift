import SwiftUI

struct RouletteWheel: View {
    @Binding var segmentCount: Int
    @Binding var items: [String]
    @Binding var colors: [Color]
    @Binding var rotation: Double
    @State var radius: CGFloat = 0

    var size: CGFloat
    var spin: () -> Void
    var onDragChanged: (Double) -> Void = { _ in }
    var onDragEnded: (Double) -> Void = { _ in }

    // MARK: - Drag Tracking State

    @State private var previousDragAngle: Double?
    @State private var dragSamples: [(time: TimeInterval, angle: Double)] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Outer ring
                Circle()
                    .strokeBorder(.white, lineWidth: 4)
                    .frame(width: size + 8, height: size + 8)

                // Segments
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
                            .font(Typography.cardTitle)
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

                // Center orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.Background.elevated, Theme.Background.primary],
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .strokeBorder(.white.opacity(0.6), lineWidth: 2)
                    )

                // Arrow indicator
                Arrow()
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(180))
                    .offset(x: 150)
                    .shadow(color: .white.opacity(0.5), radius: 8, x: 2, y: 2)
            }
            .drawingGroup()
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        handleDragChanged(value: value, in: geo)
                    }
                    .onEnded { _ in
                        handleDragEnded()
                    }
            )
            .onTapGesture {
                spin()
            }
        }
        .frame(width: size, height: size)
    }

    // MARK: - Drag Handling

    private func handleDragChanged(value: DragGesture.Value, in geo: GeometryProxy) {
        let center = CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height / 2
        )

        let dx = value.location.x - center.x
        let dy = value.location.y - center.y
        let currentAngle = atan2(dy, dx) * 180 / .pi

        if let previous = previousDragAngle {
            var delta = currentAngle - previous
            // Handle wrap-around at +-180
            if delta > 180 { delta -= 360 }
            if delta < -180 { delta += 360 }

            onDragChanged(delta)

            // Store sample for velocity estimation
            let now = ProcessInfo.processInfo.systemUptime
            dragSamples.append((time: now, angle: delta))
            // Keep only last 5 samples
            if dragSamples.count > 5 {
                dragSamples.removeFirst(dragSamples.count - 5)
            }
        }

        previousDragAngle = currentAngle
    }

    private func handleDragEnded() {
        previousDragAngle = nil

        // Estimate angular velocity from recent samples
        guard dragSamples.count >= 2 else {
            dragSamples.removeAll()
            return
        }

        let totalAngle = dragSamples.reduce(0.0) { $0 + $1.angle }
        let totalTime = dragSamples.last!.time - dragSamples.first!.time

        dragSamples.removeAll()

        guard totalTime > 0 else { return }

        let velocity = totalAngle / totalTime // degrees per second
        // Only trigger deceleration if flick has meaningful velocity
        if abs(velocity) > 50 {
            onDragEnded(velocity)
        }
    }

    // MARK: - Angle Calculation

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
    @Previewable @State var colors: [Color] = Array(Theme.wheelColors.prefix(5))
    @Previewable @State var rotation: Double = 0

    ZStack {
        GameBackground()
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
                .foregroundStyle(.white)
        }
    }
}
