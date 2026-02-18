import XCTest
@testable import Rolld

final class AppStateTests: XCTestCase {

    private var sut: AppState!

    override func setUp() {
        super.setUp()
        sut = AppState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - addNewPlayer

    func test_addNewPlayer_appendsToAllPlayers() {
        sut.addNewPlayer("Alice")

        XCTAssertEqual(sut.allPlayers, ["Alice"])
    }

    func test_addNewPlayer_multiple_appendsInOrder() {
        sut.addNewPlayer("Alice")
        sut.addNewPlayer("Bob")

        XCTAssertEqual(sut.allPlayers, ["Alice", "Bob"])
    }

    // MARK: - setCurrentPlayer

    func test_setCurrentPlayer_updatesCurrentPlayer() {
        sut.setCurrentPlayer("Alice")

        XCTAssertEqual(sut.currentPlayer, "Alice")
    }

    // MARK: - addToPreviousPlayers

    func test_addToPreviousPlayers_appendsToPreviousPlayers() {
        sut.addToPreviousPlayers("Alice")

        XCTAssertEqual(sut.previousPlayers, ["Alice"])
    }

    func test_addToPreviousPlayers_clearsCurrentPlayer() {
        sut.setCurrentPlayer("Alice")
        sut.addToPreviousPlayers("Alice")

        XCTAssertEqual(sut.currentPlayer, "")
    }

    // MARK: - deletePlayers

    func test_deletePlayers_removesFromAllPlayers() {
        sut.addNewPlayer("Alice")
        sut.addNewPlayer("Bob")
        sut.addNewPlayer("Charlie")

        sut.deletePlayers(at: IndexSet(integer: 1))

        XCTAssertEqual(sut.allPlayers, ["Alice", "Charlie"])
    }

    func test_deletePlayers_removesFromPreviousPlayers() {
        sut.addNewPlayer("Alice")
        sut.addNewPlayer("Bob")
        sut.addToPreviousPlayers("Bob")

        sut.deletePlayers(at: IndexSet(integer: 1))

        XCTAssertEqual(sut.previousPlayers, [])
    }

    func test_deletePlayers_clearsCurrentPlayerIfDeleted() {
        sut.addNewPlayer("Alice")
        sut.addNewPlayer("Bob")
        sut.setCurrentPlayer("Alice")

        sut.deletePlayers(at: IndexSet(integer: 0))

        XCTAssertEqual(sut.currentPlayer, "")
    }

    func test_deletePlayers_keepsCurrentPlayerIfNotDeleted() {
        sut.addNewPlayer("Alice")
        sut.addNewPlayer("Bob")
        sut.setCurrentPlayer("Bob")

        sut.deletePlayers(at: IndexSet(integer: 0))

        XCTAssertEqual(sut.currentPlayer, "Bob")
    }

    // MARK: - reset

    func test_reset_clearsCurrentPlayer() {
        sut.setCurrentPlayer("Alice")
        sut.reset()

        XCTAssertEqual(sut.currentPlayer, "")
    }

    func test_reset_clearsPreviousPlayers() {
        sut.addToPreviousPlayers("Alice")
        sut.addToPreviousPlayers("Bob")
        sut.reset()

        XCTAssertEqual(sut.previousPlayers, [])
    }

    func test_reset_preservesAllPlayers() {
        sut.addNewPlayer("Alice")
        sut.addNewPlayer("Bob")
        sut.reset()

        XCTAssertEqual(sut.allPlayers, ["Alice", "Bob"])
    }
}
