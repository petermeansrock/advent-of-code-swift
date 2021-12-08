import Foundation

/// A 64-bit, unsigned integer with convenience methods for working with binary representations.
public struct BinaryUInt64 {
    /// The integer value.
    public let integerValue: UInt64
    /// The binary value.
    public let binaryValue: String
    /// The number of bits used to represent the number.
    public let bitCount: Int

    /// Creates an instance from an integer value.
    ///
    /// - Parameters:
    ///  - integerValue: An integer value.
    ///  - bitCount: The number of bits to use to express the number.
    public init?(from integerValue: UInt64, with bitCount: Int) {
        let binaryValue = String(integerValue, radix: 2)
        guard binaryValue.count <= bitCount else {
            return nil
        }

        self.integerValue = integerValue
        self.binaryValue = String(repeating: "0", count: bitCount - binaryValue.count) + binaryValue
        self.bitCount = bitCount
    }

    /// Creates an instance from an integer value.
    ///
    /// - Parameter binaryValue: A binary value.
    public init?(from binaryValue: String) {
        guard let integerValue = UInt64(binaryValue, radix: 2) else {
            return nil
        }

        self.integerValue = integerValue
        self.binaryValue = binaryValue
        self.bitCount = binaryValue.count
    }
}
