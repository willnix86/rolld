import XCTest
@testable import Rolld

final class ForfeitSelectionViewModelTests: XCTestCase {

    private var sut: ForfeitSelectionViewModel!

    override func setUp() {
        super.setUp()
        sut = ForfeitSelectionViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_selectedForfeitsHasSixEmptySlots() {
        XCTAssertEqual(sut.selectedForfeits.count, 6)
        XCTAssertTrue(sut.selectedForfeits.allSatisfy { $0.isEmpty })
    }

    func test_initialState_isSpinningIsFalse() {
        XCTAssertFalse(sut.isSpinning)
    }

    func test_initialState_hasSpunAgainIsFalse() {
        XCTAssertFalse(sut.hasSpunAgain)
    }

    func test_initialState_lockedIndicesIsEmpty() {
        XCTAssertTrue(sut.lockedIndices.isEmpty)
    }

    func test_initialState_cardScalesHasSixOnes() {
        XCTAssertEqual(sut.cardScales.count, 6)
        XCTAssertTrue(sut.cardScales.allSatisfy { $0 == 1.0 })
    }

    // MARK: - onAppear

    func test_onAppear_setsIsSpinningTrue() {
        sut.onAppear(playerName: "Alice")

        XCTAssertTrue(sut.isSpinning)
    }

    func test_onAppear_populatesSixForfeitsAfterCompletion() {
        let expectation = expectation(description: "Forfeits populated")

        sut.onAppear(playerName: "Alice")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6.0)

        XCTAssertEqual(sut.selectedForfeits.count, 6)
        XCTAssertTrue(sut.selectedForfeits.allSatisfy { !$0.isEmpty })
    }

    // MARK: - didTapSpinAgain

    func test_didTapSpinAgain_setsHasSpunAgainTrue() {
        sut.onAppear(playerName: "Alice")

        let expectation = expectation(description: "First spin completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6.0)

        sut.didTapSpinAgain()

        XCTAssertTrue(sut.hasSpunAgain)
    }

    func test_didTapSpinAgain_doesNothingOnSecondCall() {
        sut.onAppear(playerName: "Alice")

        let expectation = expectation(description: "First spin completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6.0)

        sut.didTapSpinAgain()

        let expectation2 = expectation(description: "Second spin completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 6.0)

        let forfeitsAfterFirstSpin = sut.selectedForfeits
        sut.didTapSpinAgain()

        // Should not start spinning again
        XCTAssertFalse(sut.isSpinning)
        XCTAssertEqual(sut.selectedForfeits, forfeitsAfterFirstSpin)
    }

    // MARK: - lockedIndices

    func test_lockedIndices_fillsUpAfterSpinCompletes() {
        let expectation = expectation(description: "Spin completes")

        sut.onAppear(playerName: "Alice")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6.0)

        XCTAssertEqual(sut.lockedIndices.count, 6)
    }

    // MARK: - cardScales

    func test_cardScales_resetToOneAfterSpinCompletes() {
        let expectation = expectation(description: "Spin completes")

        sut.onAppear(playerName: "Alice")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6.0)

        XCTAssertTrue(sut.cardScales.allSatisfy { $0 == 1.0 })
    }

    // MARK: - Forfeits List

    func test_forfeitsListIsNotEmpty() {
        XCTAssertFalse(sut.forfeits.isEmpty)
    }
}
