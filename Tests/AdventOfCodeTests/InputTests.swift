import XCTest

@testable import AdventOfCode

class InputTests: XCTestCase {
    func testInputFileLoadLines() throws {
        // Arrange
        let inputFile = InputFile(bundle: Bundle.module, day: 1)

        // Act
        let lines = inputFile.loadLines()

        // Assert
        XCTAssertEqual(lines[0], "one")
    }

    func testInputFileLoadLineChunks() throws {
        // Arrange
        let inputFile = InputFile(bundle: Bundle.module, day: 1)

        // Act
        let chunks = inputFile.loadLineChunks()

        // Assert
        XCTAssertEqual(chunks[0][0], "one")
        XCTAssertEqual(chunks[0][1], "chunk")
        XCTAssertEqual(chunks[1][0], "another")
        XCTAssertEqual(chunks[1][1], "chunk")
    }
}
