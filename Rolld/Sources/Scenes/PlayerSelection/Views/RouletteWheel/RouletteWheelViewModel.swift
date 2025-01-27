import Combine
import Foundation
import SwiftUI

final class RouletteWheelViewModel: ObservableObject {
    @Published var segmentCount = 1
    @Published var rotation: Double = 0
    @Published var isSpinning = false
    @Published var winningItem: String = ""
    @Published var showAlert = false
    @Published var usedColors: [Color] = [.blue]
    @Published var colors: [Color] = [.gray.opacity(0.3)]
    @Published var usedColorNames: [Color] = [.blue]
    @Published var availableNames: [String] = [""]
    @Published var winningColor: [String] = []
    @Published var newColorName: String = ""

    var selectedColor: Color = .blue
    var lastUsedColor: Color = .clear
    var availableColors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
    let totalSpinDuration: Double = 5.0
    let totalRotations: Double = 3500

    private var names: [String] = []
    private var hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    func onAppear(namesToExclude: [String]) {
        if !namesToExclude.isEmpty {
            availableNames = names.filter { !namesToExclude.contains($0) }
            segmentCount = availableNames.count
        }
        hapticGenerator.prepare()
    }

    func spinRoulette() {
        guard !isSpinning else { return }
        isSpinning = true

        // Normalize the current rotation to 0–360 degrees
        let currentRotation = rotation.truncatingRemainder(dividingBy: 360)
        let normalizedRotation = currentRotation < 0 ? currentRotation + 360 : currentRotation

        // Add random extra rotations and calculate total target rotation
        let randomExtraRotations = Double.random(in: 3...5) * 360
        let totalTargetRotation = randomExtraRotations + normalizedRotation

        // Update the rotation value to spin
        withAnimation(Animation.timingCurve(0.1, 0.8, 0.3, 1.0, duration: totalSpinDuration)) {
            rotation += totalTargetRotation
        }

        // Determine the winning item based on the final wheel position
        DispatchQueue.main.asyncAfter(deadline: .now() + totalSpinDuration) { [weak self] in
            guard let self = self else { return }

            // Calculate the final rotation and normalize to 0–360
            let finalRotation = self.rotation.truncatingRemainder(dividingBy: 360)
            let normalizedFinalRotation = finalRotation < 0 ? finalRotation + 360 : finalRotation

            // Calculate the winning index based on the segment angle
            let segmentAngle = 360.0 / Double(self.segmentCount)
            let adjustedRotation = 360.0 - normalizedFinalRotation // Adjust for clockwise rotation
            let winningIndex = Int(adjustedRotation / segmentAngle) % self.segmentCount

            // Update the winning item
            self.winningItem = self.names[winningIndex]

            // Finish spinning
            self.isSpinning = false
            self.showAlert = true
        }
    }

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
        availableNames = names
        segmentCount = availableNames.count
    }
}
