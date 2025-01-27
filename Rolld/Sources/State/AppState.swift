import SwiftUI

@Observable
final class AppState {
    private(set) var currentPlayer: String = ""
    private(set) var previousPlayers: [String] = []

    func setCurrentPlayer(_ player: String) {
        currentPlayer = player
    }

    func addToPreviousPlayers(_ player: String) {
        previousPlayers.append(player)
        currentPlayer = ""
    }

    func reset() {
        currentPlayer = ""
        previousPlayers.removeAll()
    }
}
