import XCTest
@testable import Library

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
        XCTAssertEqual(thrownError as! Coordinate.RelativeOrientationError, .pointsAreNotPerfectlyAligned)
    }
}

class LineSegmentTests: XCTestCase {
    func testInitDeterminationOfOrientation() throws {
        // Arrange
        let start = Coordinate(x: 0, y: 0)
        let end = Coordinate(x: 5, y: 0)
        
        // Act
        let segment = try! LineSegment(from: start, to: end)
        
        // Assert
        XCTAssertEqual(segment.orientation, .horizontal)
    }
    
    func testInitPropagatesOrientationError() throws {
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
        XCTAssertEqual(thrownError as! Coordinate.RelativeOrientationError, .pointsAreNotPerfectlyAligned)
    }
}
