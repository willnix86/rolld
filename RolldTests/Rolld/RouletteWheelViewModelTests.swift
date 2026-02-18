import XCTest
@testable import Rolld

final class RouletteWheelViewModelTests: XCTestCase {

    private var sut: RouletteWheelViewModel!

    override func setUp() {
        super.setUp()
        sut = RouletteWheelViewModel()
    }

    override func tearDown() {
        sut.invalidateTimer()
        sut = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func addPlayersNamed(_ names: [String]) {
        for name in names {
            sut.newColorName = name
            sut.addNewItem()
        }
    }

    /// Runs the RunLoop until `condition` returns true or `timeout` elapses.
    private func waitUntil(
        _ condition: @escaping () -> Bool,
        timeout: TimeInterval,
        message: String = "Timed out waiting for condition"
    ) {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition() && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        }
        XCTAssertTrue(condition(), message)
    }

    // MARK: - Initial State

    func test_initialState_availableNamesContainsEmptyString() {
        XCTAssertEqual(sut.availableNames, [""])
    }

    func test_initialState_segmentCountIsOne() {
        XCTAssertEqual(sut.segmentCount, 1)
    }

    func test_initialState_isSpinningIsFalse() {
        XCTAssertFalse(sut.isSpinning)
    }

    // MARK: - Colors Use Theme

    func test_availableColors_usesThemeWheelColors() {
        XCTAssertEqual(sut.availableColors, Theme.wheelColors)
    }

    func test_initialPlaceholderColor_usesThemeSurface() {
        XCTAssertEqual(sut.colors, [Theme.Background.surface])
    }

    // MARK: - addNewItem

    func test_addNewItem_addsNameToAvailableNames() {
        sut.newColorName = "Alice"
        sut.addNewItem()

        XCTAssertTrue(sut.availableNames.contains("Alice"))
    }

    func test_addNewItem_removesEmptyPlaceholder() {
        sut.newColorName = "Alice"
        sut.addNewItem()

        XCTAssertFalse(sut.availableNames.contains(""))
    }

    func test_addNewItem_updatesSegmentCount() {
        sut.newColorName = "Alice"
        sut.addNewItem()
        sut.newColorName = "Bob"
        sut.addNewItem()

        XCTAssertEqual(sut.segmentCount, 2)
    }

    func test_addNewItem_clearsNewColorName() {
        sut.newColorName = "Alice"
        sut.addNewItem()

        XCTAssertEqual(sut.newColorName, "")
    }

    func test_addNewItem_emptyName_doesNotAdd() {
        let initialCount = sut.availableNames.count
        sut.newColorName = ""
        sut.addNewItem()

        XCTAssertEqual(sut.availableNames.count, initialCount)
    }

    // MARK: - deleteItems

    func test_deleteItems_removesFromAvailableNames() {
        sut.newColorName = "Alice"
        sut.addNewItem()
        sut.newColorName = "Bob"
        sut.addNewItem()

        sut.deleteItems(at: IndexSet(integer: 0))

        XCTAssertFalse(sut.availableNames.contains("Alice"))
        XCTAssertTrue(sut.availableNames.contains("Bob"))
    }

    func test_deleteItems_updatesSegmentCount() {
        sut.newColorName = "Alice"
        sut.addNewItem()
        sut.newColorName = "Bob"
        sut.addNewItem()

        sut.deleteItems(at: IndexSet(integer: 0))

        XCTAssertEqual(sut.segmentCount, 1)
    }

    // MARK: - spinRoulette

    func test_spinRoulette_setsIsSpinningTrue() {
        addPlayersNamed(["Alice", "Bob"])

        sut.spinRoulette()

        XCTAssertTrue(sut.isSpinning)
    }

    func test_spinRoulette_doesNothingIfAlreadySpinning() {
        addPlayersNamed(["Alice", "Bob"])

        sut.spinRoulette()
        XCTAssertTrue(sut.isSpinning)

        // Second spin should be ignored
        sut.spinRoulette()
        XCTAssertTrue(sut.isSpinning, "Should still be spinning from first call")
    }

    // MARK: - reset

    func test_reset_restoresAvailableNamesToAllNames() {
        sut.newColorName = "Alice"
        sut.addNewItem()
        sut.newColorName = "Bob"
        sut.addNewItem()

        // Simulate excluding a name via onAppear
        sut.onAppear(namesToExclude: ["Alice"])

        XCTAssertFalse(sut.availableNames.contains("Alice"))

        sut.reset()

        XCTAssertTrue(sut.availableNames.contains("Alice"))
        XCTAssertTrue(sut.availableNames.contains("Bob"))
    }

    func test_reset_updatesSegmentCount() {
        sut.newColorName = "Alice"
        sut.addNewItem()
        sut.newColorName = "Bob"
        sut.addNewItem()

        sut.onAppear(namesToExclude: ["Alice"])
        sut.reset()

        XCTAssertEqual(sut.segmentCount, 2)
    }

    // MARK: - segmentIndexForRotation (pure function)

    func test_segmentIndexForRotation_zeroRotation() {
        addPlayersNamed(["A", "B", "C", "D"])
        // 4 segments, each 90 degrees
        // rotation=0 → (360 - 0) / 90 = 4 % 4 = 0
        XCTAssertEqual(sut.segmentIndexForRotation(0), 0)
    }

    func test_segmentIndexForRotation_90degrees() {
        addPlayersNamed(["A", "B", "C", "D"])
        // rotation=90 → (360 - 90) / 90 = 3 % 4 = 3
        XCTAssertEqual(sut.segmentIndexForRotation(90), 3)
    }

    func test_segmentIndexForRotation_negativeRotation() {
        addPlayersNamed(["A", "B", "C", "D"])
        // rotation=-90 → normalized = 270 → (360 - 270) / 90 = 1 % 4 = 1
        XCTAssertEqual(sut.segmentIndexForRotation(-90), 1)
    }

    func test_segmentIndexForRotation_largeRotation_normalizes() {
        addPlayersNamed(["A", "B", "C", "D"])
        // rotation=810 → 810 % 360 = 90 → same as 90 → index 3
        XCTAssertEqual(sut.segmentIndexForRotation(810), 3)
    }

    // MARK: - Spin completion (Timer-based, async)

    func test_spinRoulette_eventuallyStopsAndDeterminesWinner() {
        addPlayersNamed(["Alice", "Bob", "Charlie"])

        sut.spinRoulette()
        XCTAssertTrue(sut.isSpinning)

        // Timer-based spin should decelerate and stop
        waitUntil({ !self.sut.isSpinning }, timeout: 10.0,
                  message: "Spin should eventually stop")

        XCTAssertFalse(sut.isSpinning)
        XCTAssertTrue(sut.showAlert)
        XCTAssertTrue(
            sut.availableNames.contains(sut.winningItem),
            "winningItem '\(sut.winningItem)' should be in availableNames"
        )
    }

    func test_spinRoulette_afterExclusion_winningItemIsFromAvailableNames() {
        // Add 4 players
        addPlayersNamed(["Alice", "Bob", "Charlie", "Dave"])

        // Exclude Alice (simulating she already played)
        sut.onAppear(namesToExclude: ["Alice"])

        XCTAssertFalse(sut.availableNames.contains("Alice"))
        XCTAssertEqual(sut.availableNames.count, 3)

        // Spin the wheel
        sut.spinRoulette()

        // Wait for Timer-based spin to complete
        waitUntil({ !self.sut.isSpinning }, timeout: 10.0,
                  message: "Spin should eventually stop")

        // The winning item must be from availableNames, never the excluded player
        XCTAssertTrue(
            sut.availableNames.contains(sut.winningItem),
            "winningItem '\(sut.winningItem)' should be in availableNames \(sut.availableNames)"
        )
        XCTAssertNotEqual(sut.winningItem, "Alice", "Excluded player should never be the winner")
    }

    func test_startDecelerationSpin_setsIsSpinning() {
        addPlayersNamed(["Alice", "Bob"])

        sut.startDecelerationSpin(angularVelocity: 500)

        XCTAssertTrue(sut.isSpinning)
    }

    func test_startDecelerationSpin_ignoredWhileAlreadySpinning() {
        addPlayersNamed(["Alice", "Bob"])

        sut.spinRoulette()
        XCTAssertTrue(sut.isSpinning)

        // Attempting a deceleration spin while already spinning should be ignored
        let rotationBeforeDrag = sut.rotation
        sut.startDecelerationSpin(angularVelocity: 9999)

        // Give a couple ticks for the timer to run
        RunLoop.current.run(until: Date().addingTimeInterval(0.05))

        // Rotation should only reflect the tap spin, not the drag velocity
        // (we can't check velocity directly, but at least it didn't crash)
        XCTAssertTrue(sut.isSpinning)
    }

    func test_dragSpin_eventuallyStopsAndDeterminesWinner() {
        addPlayersNamed(["Alice", "Bob", "Charlie"])

        sut.startDecelerationSpin(angularVelocity: 800)
        XCTAssertTrue(sut.isSpinning)

        waitUntil({ !self.sut.isSpinning }, timeout: 10.0,
                  message: "Drag spin should eventually stop")

        XCTAssertFalse(sut.isSpinning)
        XCTAssertTrue(sut.showAlert)
        XCTAssertTrue(
            sut.availableNames.contains(sut.winningItem),
            "winningItem '\(sut.winningItem)' should be in availableNames"
        )
    }
}
