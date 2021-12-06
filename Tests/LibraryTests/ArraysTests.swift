import Foundation
import XCTest

@testable import Library

class ArraysTests: XCTestCase {
    func testColumnWithTwoDimensionalArrayOfIntegers() throws {
        // Arrange
        let input = [
            [0, 1, 2],
            [0, 1, 2],
            [0, 1, 2],
        ]

        // Act
        let output = input.column(at: 1)

        // Assert
        XCTAssertEqual(output, [1, 1, 1])
    }

    func testColumnWithTwoDimensionalArrayOfStrings() throws {
        // Arrange
        let input = [
            ["0", "1", "2"],
            ["0", "1", "2"],
            ["0", "1", "2"],
        ]

        // Act
        let output = input.column(at: 1)

        // Assert
        XCTAssertEqual(output, ["1", "1", "1"])
    }

    func testColumnsWithTwoDimensionalArrayOfIntegers() throws {
        // Arrange
        let input = [
            [0, 1, 2],
            [0, 1, 2],
            [0, 1, 2],
        ]

        // Act
        let output = input.columns()

        // Assert
        XCTAssertEqual(output, [[0, 0, 0], [1, 1, 1], [2, 2, 2]])
    }

    func testColumnsWithTwoDimensionalArrayOfStrings() throws {
        // Arrange
        let input = [
            ["0", "1", "2"],
            ["0", "1", "2"],
            ["0", "1", "2"],
        ]

        // Act
        let output = input.columns()

        // Assert
        XCTAssertEqual(output, [["0", "0", "0"], ["1", "1", "1"], ["2", "2", "2"]])
    }

    func testStrideToleratingZeroWithZeroStep() {
        // Arrange
        let seq = strideToleratingZero(from: 1, through: 1, by: 0)

        // Act
        let values = Array(seq.prefix(3))

        // Assert
        XCTAssertEqual(values, [1, 1, 1])
    }

    func testStrideToleratingZeroWithNonZeroStep() {
        // Arrange
        let seq = strideToleratingZero(from: 1, through: 3, by: 1)

        // Act
        let values = Array(seq.prefix(5))

        // Assert
        XCTAssertEqual(values, [1, 2, 3])
    }
}
