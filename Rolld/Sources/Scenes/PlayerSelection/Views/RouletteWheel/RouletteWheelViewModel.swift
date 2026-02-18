import Combine
import Foundation
import SwiftUI

// MARK: - Haptic Feedback Protocol

protocol HapticFeedbackProvider {
    func prepare()
    func impactOccurred()
}

extension UIImpactFeedbackGenerator: HapticFeedbackProvider {}

// MARK: - RouletteWheelViewModel

final class RouletteWheelViewModel: ObservableObject {
    @Published var segmentCount = 1
    @Published var rotation: Double = 0
    @Published var isSpinning = false
    @Published var winningItem: String = ""
    @Published var showAlert = false
    @Published var usedColors: [Color] = [Theme.wheelColors.first ?? .blue]
    @Published var colors: [Color] = [Theme.Background.surface]
    @Published var usedColorNames: [Color] = [Theme.wheelColors.first ?? .blue]
    @Published var availableNames: [String] = [""]
    @Published var winningColor: [String] = []
    @Published var newColorName: String = ""

    var selectedColor: Color = Theme.wheelColors.first ?? .blue
    var lastUsedColor: Color = .clear
    var availableColors: [Color] = Theme.wheelColors

    // MARK: - Physics Constants

    private let friction: Double = 0.98
    private let stopThreshold: Double = 5.0
    private let tapSpinVelocityRange: ClosedRange<Double> = 1600...2000
    private let hapticMinInterval: TimeInterval = 0.04 // 40ms, max 25/sec

    // MARK: - Animation State

    private var animationTimer: Timer?
    private var angularVelocity: Double = 0
    private var lastHapticTime: TimeInterval = 0
    private var lastSegmentIndex: Int = -1

    private var names: [String] = []
    private var hapticGenerator: HapticFeedbackProvider

    // MARK: - Init

    init(hapticProvider: HapticFeedbackProvider? = nil) {
        self.hapticGenerator = hapticProvider ?? UIImpactFeedbackGenerator(style: .light)
    }

    // MARK: - Lifecycle

    func onAppear(namesToExclude: [String]) {
        if !namesToExclude.isEmpty {
            availableNames = names.filter { !namesToExclude.contains($0) }
            segmentCount = availableNames.count
        }
        hapticGenerator.prepare()
    }

    func invalidateTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    // MARK: - Spin (Tap)

    func spinRoulette() {
        guard !isSpinning else { return }
        isSpinning = true

        let velocity = Double.random(in: tapSpinVelocityRange)
        angularVelocity = velocity
        lastSegmentIndex = segmentIndexForRotation(rotation)
        startAnimationTimer()
    }

    // MARK: - Drag Support

    func applyDragDelta(_ angleDelta: Double) {
        guard !isSpinning else { return }

        let oldRotation = rotation
        rotation += angleDelta
        checkSegmentCrossing(oldRotation: oldRotation, newRotation: rotation)
    }

    func startDecelerationSpin(angularVelocity velocity: Double) {
        guard !isSpinning else { return }
        isSpinning = true

        angularVelocity = velocity
        lastSegmentIndex = segmentIndexForRotation(rotation)
        startAnimationTimer()
    }

    // MARK: - Segment Index (Pure, Testable)

    func segmentIndexForRotation(_ rotationDegrees: Double) -> Int {
        guard segmentCount > 0 else { return 0 }

        let segmentAngle = 360.0 / Double(segmentCount)

        // Normalize to 0–360
        var normalized = rotationDegrees.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }

        // Arrow points right (0 degrees). Clockwise rotation means segment index decreases.
        let adjusted = 360.0 - normalized
        return Int(adjusted / segmentAngle) % segmentCount
    }

    // MARK: - Animation Timer

    private func startAnimationTimer() {
        invalidateTimer()

        let dt = 1.0 / 60.0
        animationTimer = Timer.scheduledTimer(withTimeInterval: dt, repeats: true) { [weak self] _ in
            self?.animationTick(dt: dt)
        }
    }

    private func animationTick(dt: Double) {
        let oldRotation = rotation

        rotation += angularVelocity * dt
        angularVelocity *= friction

        checkSegmentCrossing(oldRotation: oldRotation, newRotation: rotation)

        if abs(angularVelocity) < stopThreshold {
            stopSpin()
        }
    }

    // MARK: - Segment Crossing + Haptics

    private func checkSegmentCrossing(oldRotation: Double, newRotation: Double) {
        let oldIndex = segmentIndexForRotation(oldRotation)
        let newIndex = segmentIndexForRotation(newRotation)

        if oldIndex != newIndex {
            lastSegmentIndex = newIndex
            fireSegmentHaptic()
        }
    }

    private func fireSegmentHaptic() {
        let now = ProcessInfo.processInfo.systemUptime
        guard now - lastHapticTime >= hapticMinInterval else { return }

        lastHapticTime = now
        hapticGenerator.impactOccurred()
    }

    // MARK: - Stop Spin

    private func stopSpin() {
        invalidateTimer()
        angularVelocity = 0

        // Determine winner from final position
        let winningIndex = segmentIndexForRotation(rotation)
        if winningIndex < availableNames.count {
            winningItem = availableNames[winningIndex]
        }

        isSpinning = false
        showAlert = true
    }

    // MARK: - Add / Delete / Reset

    func addNewItem() {
        guard !newColorName.isEmpty else { return }
        availableNames.removeAll(where: { $0 == "" })
        addNewColorAndName(name: newColorName)
        segmentCount = availableNames.count
        newColorName = ""
    }

    func deleteItems(at offset: IndexSet) {
        let playersToDelete = offset.map { names[$0] }

        names.remove(atOffsets: offset)
        availableNames.removeAll { playersToDelete.contains($0) }

        segmentCount = availableNames.count
        if names.isEmpty {
            names = [""]
            segmentCount = 1
        }
    }

    func addNewColorAndName(name: String) {
        // Determine the next color in the available colors array
        if let nextColorIndex = availableColors.firstIndex(of: lastUsedColor) {
            let nextIndex = (nextColorIndex + 1) % availableColors.count // Loop through colors
            let nextColor = availableColors[nextIndex]
            colors.append(nextColor)
            usedColors.append(nextColor)
            lastUsedColor = nextColor
            names.append(name)
            availableNames.append(name)
        } else {
            // If `lastUsedColor` is not in `availableColors`, start from the first color
            let firstColor = availableColors.first ?? .gray
            colors.append(firstColor)
            usedColors.append(firstColor)
            lastUsedColor = firstColor
            names.append(name)
            availableNames.append(name)
        }
    }

    func reset() {
        invalidateTimer()
        angularVelocity = 0
        availableNames = names
        segmentCount = availableNames.count
    }
}
