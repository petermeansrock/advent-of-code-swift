import Foundation
@testable import Library
import XCTest

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
}
