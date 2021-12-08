import XCTest

@testable import AdventOfCode

class InputTests: XCTestCase {
    func testInputFileLoadLines() throws {
        // Arrange
        let inputFile = InputFile(bundle: Bundle.module, day: 1)

        // Act
        let lines = inputFile.loadLines()

        // Assert
        XCTAssertEqual(lines[0], "170")
    }
}
