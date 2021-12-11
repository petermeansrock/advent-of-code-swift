import Foundation
import XCTest

@testable import AdventOfCode

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

    func testNeighborsWithHorizontalAdjacency() {
        // Arrange
        let input = [
            [0, 0, 0],
            [1, 0, 2],
            [0, 0, 0],
        ]

        // Act
        let neighbors = input.neighbors(row: 1, column: 1, adjacencies: [.horizontal])

        // Assert
        XCTAssertEqual(neighbors.count, 2)
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 1, column: 0, value: 1) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 1, column: 2, value: 2) }))
    }

    func testNeighborsWithVerticalAdjacency() {
        // Arrange
        let input = [
            [0, 1, 0],
            [0, 0, 0],
            [0, 2, 0],
        ]

        // Act
        let neighbors = input.neighbors(row: 1, column: 1, adjacencies: [.vertical])

        // Assert
        XCTAssertEqual(neighbors.count, 2)
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 1, value: 1) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 2, column: 1, value: 2) }))
    }

    func testNeighborsWithDiagonalAdjacency() {
        // Arrange
        let input = [
            [1, 0, 2],
            [0, 0, 0],
            [3, 0, 4],
        ]

        // Act
        let neighbors = input.neighbors(row: 1, column: 1, adjacencies: [.diagonal])

        // Assert
        XCTAssertEqual(neighbors.count, 4)
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 0, value: 1) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 2, value: 2) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 2, column: 0, value: 3) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 2, column: 2, value: 4) }))
    }

    func testNeighborsWithAllAdjacencies() {
        // Arrange
        let input = [
            [5, 3, 6],
            [1, 0, 2],
            [7, 4, 8],
        ]

        // Act
        let neighbors = input.neighbors(row: 1, column: 1, adjacencies: Set(Adjacency.allCases))

        // Assert
        XCTAssertEqual(neighbors.count, 8)
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 1, column: 0, value: 1) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 1, column: 2, value: 2) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 1, value: 3) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 2, column: 1, value: 4) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 0, value: 5) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 2, value: 6) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 2, column: 0, value: 7) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 2, column: 2, value: 8) }))
    }

    func testNeighborsWithAllAdjacenciesAgainstBounds() {
        // Arrange
        let input = [
            [0, 1],
            [2, 3],
        ]

        // Act
        let neighbors = input.neighbors(row: 0, column: 0, adjacencies: Set(Adjacency.allCases))

        // Assert
        XCTAssertEqual(neighbors.count, 3)
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 0, column: 1, value: 1) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 1, column: 0, value: 2) }))
        XCTAssertTrue(neighbors.contains(where: { $0 == (row: 1, column: 1, value: 3) }))
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
