import SwiftUI

@Observable
final class AppState {
    private(set) var allPlayers: [String] = []
    private(set) var currentPlayer: String = ""
    private(set) var previousPlayers: [String] = []

    func addNewPlayer(_ player: String) {
        allPlayers.append(player)
    }

    func setCurrentPlayer(_ player: String) {
        currentPlayer = player
    }

    func addToPreviousPlayers(_ player: String) {
        previousPlayers.append(player)
        currentPlayer = ""
    }

    func deletePlayers(at offset: IndexSet) {
        let playersToDelete = offset.map { allPlayers[$0] }

        allPlayers.remove(atOffsets: offset)

        previousPlayers.removeAll { playersToDelete.contains($0) }

        if playersToDelete.contains(currentPlayer) {
            currentPlayer = ""
        }
    }

    func reset() {
        currentPlayer = ""
        previousPlayers.removeAll()
    }
}
