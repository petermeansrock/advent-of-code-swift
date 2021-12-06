import Foundation
import XCTest

@testable import Library

class NumbersTests: XCTestCase {
    func testInitFromBinary() throws {
        // Arrange
        let binary = "01011"

        // Act
        let number = BinaryUInt64(from: binary)!

        // Assert
        XCTAssertEqual(number.integerValue, 11)
    }

    func testInitFromBinaryWithInvalidString() throws {
        // Arrange
        let binary = "0X0XX"

        // Act
        let number = BinaryUInt64(from: binary)

        // Assert
        XCTAssertNil(number)
    }

    func testInitFromInteger() throws {
        // Arrange
        let integer = UInt64(11)

        // Act
        let number = BinaryUInt64(from: integer, with: 5)!

        // Assert
        XCTAssertEqual(number.binaryValue, "01011")
    }

    func testInitFromIntegerWithSizeTooSmall() throws {
        // Arrange
        let integer = UInt64(11)

        // Act
        let number = BinaryUInt64(from: integer, with: 2)

        // Assert
        XCTAssertNil(number)
    }
}
