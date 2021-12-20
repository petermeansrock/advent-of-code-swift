import XCTest

@testable import AdventOfCode

class StringsTests: XCTestCase {
    func testReplaceFirstMatch() throws {
        // Arrange
        let input = "123 456 789"

        // Act
        let output = try input.replaceFirstMatch(pattern: #"\d+"#) { String(Int($0)! * 2) }

        // Assert
        XCTAssertEqual(output, "246 456 789")
    }

    func testReplaceLastMatch() throws {
        // Arrange
        let input = "123 456 789"

        // Act
        let output = try input.replaceLastMatch(pattern: #"\d+"#) { String(Int($0)! * 2) }

        // Assert
        XCTAssertEqual(output, "123 456 1578")
    }

    func testCaptureGroup() throws {
        // Arrange
        let input = "this is x=5 and y=10"

        // Act
        let match = try input.firstMatch(pattern: #"x=(\d+) and y=(\d+)"#)!

        // Assert
        XCTAssertEqual(match.captureGroups.count, 2)
        XCTAssertEqual(match.captureGroups[0].substring, "5")
        XCTAssertEqual(match.captureGroups[1].substring, "10")
    }
}
