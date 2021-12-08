import XCTest

@testable import AdventOfCode

class CoordinateTests: XCTestCase {
    func testRelativeOrientationBetweenHorizontalPoints() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 5, y: 0)

        // Act
        let orientation = try start.relativeOrientation(to: end)

        // Assert
        XCTAssertEqual(orientation, .horizontal)
    }

    func testRelativeOrientationBetweenVerticalPoints() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 0, y: 5)

        // Act
        let orientation = try start.relativeOrientation(to: end)

        // Assert
        XCTAssertEqual(orientation, .vertical)
    }

    func testRelativeOrientationBetweenDiagonalPoints() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 5, y: 5)

        // Act
        let orientation = try start.relativeOrientation(to: end)

        // Assert
        XCTAssertEqual(orientation, .diagonal)
    }

    func testRelativeOrientationBetweenIdenticalPoints() throws {
        // Arrange
        let start = Coordinate(x: 5, y: 5)
        let end = Coordinate(x: 5, y: 5)

        // Act
        let orientationClosure = { try start.relativeOrientation(to: end) }

        // Assert
        var thrownError: Error?
        XCTAssertThrowsError(try orientationClosure()) {
            thrownError = $0
        }
        XCTAssertEqual(thrownError as! Coordinate.RelativeOrientationError, .pointsAreIdentical)
    }

    func testRelativeOrientationBetweenPointsWhichAreNotPerfectlyAligned() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 1, y: 2)

        // Act
        let orientationClosure = { try start.relativeOrientation(to: end) }

        // Assert
        var thrownError: Error?
        XCTAssertThrowsError(try orientationClosure()) {
            thrownError = $0
        }
        XCTAssertEqual(
            thrownError as! Coordinate.RelativeOrientationError, .pointsAreNotPerfectlyAligned)
    }

    func testHorizontalIncreasingClosedRange() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 2, y: 0)

        // Act
        let coordinates = try start...end

        // Assert
        XCTAssertEqual(coordinates.count, 3)
        XCTAssertEqual(coordinates[0], Coordinate(x: 0, y: 0))
        XCTAssertEqual(coordinates[1], Coordinate(x: 1, y: 0))
        XCTAssertEqual(coordinates[2], Coordinate(x: 2, y: 0))
    }

    func testHorizontalDecreasingClosedRange() throws {
        // Arrange
        let start = Coordinate(x: 2, y: 0)
        let end = Coordinate(x: 0, y: 0)

        // Act
        let coordinates = try start...end

        // Assert
        XCTAssertEqual(coordinates.count, 3)
        XCTAssertEqual(coordinates[0], Coordinate(x: 2, y: 0))
        XCTAssertEqual(coordinates[1], Coordinate(x: 1, y: 0))
        XCTAssertEqual(coordinates[2], Coordinate(x: 0, y: 0))
    }

    func testVerticalIncreasingClosedRange() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 0, y: 2)

        // Act
        let coordinates = try start...end

        // Assert
        XCTAssertEqual(coordinates.count, 3)
        XCTAssertEqual(coordinates[0], Coordinate(x: 0, y: 0))
        XCTAssertEqual(coordinates[1], Coordinate(x: 0, y: 1))
        XCTAssertEqual(coordinates[2], Coordinate(x: 0, y: 2))
    }

    func testVerticalDecreasingClosedRange() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 2)
        let end = Coordinate(x: 0, y: 0)

        // Act
        let coordinates = try start...end

        // Assert
        XCTAssertEqual(coordinates.count, 3)
        XCTAssertEqual(coordinates[0], Coordinate(x: 0, y: 2))
        XCTAssertEqual(coordinates[1], Coordinate(x: 0, y: 1))
        XCTAssertEqual(coordinates[2], Coordinate(x: 0, y: 0))
    }

    func testDiagonalIncreasingXIncreasingYClosedRange() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 2, y: 2)

        // Act
        let coordinates = try start...end

        // Assert
        XCTAssertEqual(coordinates.count, 3)
        XCTAssertEqual(coordinates[0], Coordinate(x: 0, y: 0))
        XCTAssertEqual(coordinates[1], Coordinate(x: 1, y: 1))
        XCTAssertEqual(coordinates[2], Coordinate(x: 2, y: 2))
    }

    func testDiagonalDecreasingXDecreasingYClosedRange() throws {
        // Arrange
        let start = Coordinate(x: 2, y: 2)
        let end = Coordinate(x: 0, y: 0)

        // Act
        let coordinates = try start...end

        // Assert
        XCTAssertEqual(coordinates.count, 3)
        XCTAssertEqual(coordinates[0], Coordinate(x: 2, y: 2))
        XCTAssertEqual(coordinates[1], Coordinate(x: 1, y: 1))
        XCTAssertEqual(coordinates[2], Coordinate(x: 0, y: 0))
    }
}

class LineSegmentTests: XCTestCase {
    func testInitWithCoordinatesDeterminationOfOrientation() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 5, y: 0)

        // Act
        let segment = try! LineSegment(from: start, to: end)

        // Assert
        XCTAssertEqual(segment.orientation, .horizontal)
    }

    func testInitWithCoordinatesPropagatesOrientationError() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 1, y: 2)

        // Act
        let initClosure = { try LineSegment(from: start, to: end) }

        // Assert
        var thrownError: Error?
        XCTAssertThrowsError(try initClosure()) {
            thrownError = $0
        }
        XCTAssertEqual(
            thrownError as! Coordinate.RelativeOrientationError, .pointsAreNotPerfectlyAligned)
    }

    func testInitWithValidStringFormat() throws {
        // Arrange
        let string = "0,9 -> 5,9"

        // Act
        let segment = try! LineSegment(in: string)

        // Assert
        XCTAssertEqual(segment.orientation, .horizontal)
    }

    func testInitWithInvalidStringFormat() throws {
        // Arrange
        let string = "0,9 to 5,9"

        // Act
        let initClosure = { try LineSegment(in: string) }

        // Assert
        var thrownError: Error?
        XCTAssertThrowsError(try initClosure()) {
            thrownError = $0
        }
        XCTAssertEqual(
            thrownError as! LineSegment.ValidationError, .stringDoesNotMatchSupportedFormat)
    }
}

class PlotTests: XCTestCase {
    func testPlotWithSampleInputIgnoringDiagonals() throws {
        // Arrange
        let lines = [
            "0,9 -> 5,9",
            "8,0 -> 0,8",
            "9,4 -> 3,4",
            "2,2 -> 2,1",
            "7,0 -> 7,4",
            "6,4 -> 2,0",
            "0,9 -> 2,9",
            "3,4 -> 1,4",
            "0,0 -> 8,8",
            "5,5 -> 8,2",
        ]
        let segments = lines.map { try! LineSegment(in: $0) }.filter { $0.orientation != .diagonal }
        let coordinates = segments.flatMap { [$0.start, $0.end] }
        let maxX = coordinates.map { $0.x }.max()!
        let maxY = coordinates.map { $0.y }.max()!

        // Act
        var plot = Plot(maxX: maxX, maxY: maxY)
        for segment in segments {
            plot.plot(line: segment)
        }

        // Assert
        let overlappingCount = plot.grid.flatMap { $0 }.filter { $0 >= 2 }.count
        XCTAssertEqual(overlappingCount, 5)
    }

    func testPlotWithSampleInputConsideringDiagonals() throws {
        // Arrange
        let lines = [
            "0,9 -> 5,9",
            "8,0 -> 0,8",
            "9,4 -> 3,4",
            "2,2 -> 2,1",
            "7,0 -> 7,4",
            "6,4 -> 2,0",
            "0,9 -> 2,9",
            "3,4 -> 1,4",
            "0,0 -> 8,8",
            "5,5 -> 8,2",
        ]
        let segments = lines.map { try! LineSegment(in: $0) }
        let coordinates = segments.flatMap { [$0.start, $0.end] }
        let maxX = coordinates.map { $0.x }.max()!
        let maxY = coordinates.map { $0.y }.max()!

        // Act
        var plot = Plot(maxX: maxX, maxY: maxY)
        for segment in segments {
            plot.plot(line: segment)
        }

        // Assert
        let overlappingCount = plot.grid.flatMap { $0 }.filter { $0 >= 2 }.count
        XCTAssertEqual(overlappingCount, 12)
    }
}
