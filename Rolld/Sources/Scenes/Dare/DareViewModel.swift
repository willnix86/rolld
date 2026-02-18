import SwiftUI

final class DareViewModel: ObservableObject {
    private enum Constants {
        static let animationInterval: CGFloat = 0.1
        static let animationDuration: Double = 2.0
    }
    
    @Published var selectedDare: String = ""
    @Published var isSpinning: Bool = false
    @Published var hasSpunAgain: Bool = false
    @Published var shuffleScale: CGFloat = 1.0

    // TODO: remove hardcoded values
    var dares = [
        "Sing a song as loud as you can.",
        "Do a silly dance for 30 seconds.",
        "Walk across the room like a crab.",
        "Speak in a funny accent for the next 5 minutes.",
        "Hop on one foot for 20 seconds.",
        "Pretend you're an animal of your choice for a minute.",
        "Spin around 10 times and try to walk in a straight line.",
        "Make the funniest face you can.",
        "Do 10 jumping jacks while counting backward.",
        "Talk like a robot for the next 3 minutes.",
        "Pretend you're invisible and act it out.",
        "Try to make everyone laugh without speaking.",
        "Say the alphabet backward as fast as you can.",
        "Pretend to be a superhero and strike your best pose.",
        "Do your best impression of someone in the room.",
        "Walk backward for the next minute without bumping into anything.",
        "Whisper everything you say for the next 5 minutes.",
        "Pretend you’re riding a horse for 30 seconds.",
        "Act out your favourite movie scene without speaking.",
        "Balance on one leg for as long as you can.",
        "Pretend you're walking on a tightrope for 30 seconds.",
        "Say something nice about everyone in the room.",
        "Pretend to take an imaginary selfie and caption it aloud.",
        "Spin in a circle 5 times, then try to touch your toes.",
        "Freeze like a statue in a funny pose for 20 seconds.",
        "Try to lick your elbow.",
        "Clap your hands as fast as you can for 10 seconds.",
        "Pretend you're a news reporter and give a weather update.",
        "Make up a silly song about something in the room.",
        "Pretend you’re swimming on dry land for 20 seconds.",
        "Tell a funny joke (or make one up on the spot).",
        "Walk around acting like a zombie for 1 minute.",
        "Count to 20 while holding your breath (if safe).",
        "Make an animal sound and see if anyone can guess what it is.",
        "Do a cartwheel or pretend to do one if you can’t.",
        "Say three things you love about your family."
    ]
    
    private var timer: Timer? = nil
    private var hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    func onAppear() {
        prepareHaptics()
        selectDares()
    }

    private func selectDares() {
        isSpinning = true

        // Create a mutable copy of dares to track remaining dares
        var remainingDares = dares.shuffled()

        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.animationInterval,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }

            // Update current dare
            var nextDare = remainingDares.randomElement() ?? ""
            while nextDare == self.selectedDare {
                nextDare = remainingDares.randomElement() ?? ""
            }
            self.selectedDare = nextDare
            self.shuffleScale = 1.05
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                self?.shuffleScale = 1.0
            }
            self.hapticGenerator.impactOccurred()
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + Constants.animationDuration
        ) { [weak self] in
            guard let self = self else { return }

            self.timer?.invalidate()

            if !remainingDares.isEmpty {
                self.selectedDare = remainingDares.removeFirst()
            }

            self.isSpinning = false
        }
    }

    private func prepareHaptics() {
        hapticGenerator.prepare()
    }
}
