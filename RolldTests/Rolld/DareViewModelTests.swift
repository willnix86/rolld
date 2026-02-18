import XCTest
@testable import Rolld

final class DareViewModelTests: XCTestCase {

    private var sut: DareViewModel!

    override func setUp() {
        super.setUp()
        sut = DareViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_selectedDareIsEmpty() {
        XCTAssertEqual(sut.selectedDare, "")
    }

    func test_initialState_isSpinningIsFalse() {
        XCTAssertFalse(sut.isSpinning)
    }

    func test_initialState_shuffleScaleIsOne() {
        XCTAssertEqual(sut.shuffleScale, 1.0)
    }

    // MARK: - onAppear

    func test_onAppear_setsIsSpinningTrue() {
        sut.onAppear()

        XCTAssertTrue(sut.isSpinning)
    }

    func test_onAppear_completesAfterDuration() {
        let expectation = expectation(description: "Spinning completes")

        sut.onAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)

        XCTAssertFalse(sut.isSpinning)
    }

    func test_onAppear_selectedDareIsNonEmptyAfterCompletion() {
        let expectation = expectation(description: "Dare selected")

        sut.onAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)

        XCTAssertFalse(sut.selectedDare.isEmpty)
    }

    func test_onAppear_shuffleScaleResetsToOneAfterCompletion() {
        let expectation = expectation(description: "Shuffle completes")

        sut.onAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)

        XCTAssertEqual(sut.shuffleScale, 1.0)
    }

    // MARK: - Dares List

    func test_daresListIsNotEmpty() {
        XCTAssertFalse(sut.dares.isEmpty)
    }
}
