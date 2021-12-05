import Foundation

/// Represents the relative orientation between two entities.
public enum Orientation {
    case horizontal
    case vertical
    case diagonal
}

/// Represents a point in space as defined by an x and y coordinate pair.
public struct Coordinate: Equatable {
    /// The x-axis value.
    public let x: Int
    /// The y-axis value.
    public let y: Int
    
    /// Creates a new instance.
    ///
    /// - Parameters:
    ///   - x: The x-axis value.
    ///   - y: The y-axis value.
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    /// Determines the relative ``Orientation`` between two coordinates.
    ///
    /// For example:
    /// - Points `(0, 0)` and `(5, 0)` are horizontally aligned as they share an x-coordinate.
    /// - Points `(0, 0)` and `(0, 5)` are vertically aligned as they share a y-coordinate.
    /// - Points `(0, 0)` and `(5, 5)` are diagonally aligned as a line with slope `1` or `-1` can
    ///   be drawn between them.
    ///
    /// - Parameter other: Another coordinate to which to determine relative orientation.
    /// - Returns: The relative orientation between the two coordinates.
    public func relativeOrientation(to other: Coordinate) throws -> Orientation {
        if self == other {
            throw RelativeOrientationError.pointsAreIdentical
        } else if self.y == other.y {
            return .horizontal
        } else if self.x == other.x {
            return .vertical
        } else if abs(self.x - other.x) == abs(self.y - other.y) {
            return .diagonal
        } else {
            throw RelativeOrientationError.pointsAreNotPerfectlyAligned
        }
    }
    
    /// Determines whether two points are equal based on comparison of their x and y values.
    ///
    /// - Returns: Returns true if the coordinates are equal, false otherwise.
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x &&
        lhs.y == rhs.y
    }
    
    /// Represents the errors that may be thrown when determining relative orientation.
    public enum RelativeOrientationError: Error {
        /// A relative orientation cannot be determined between two identical points.
        case pointsAreIdentical
        /// A relative orientation cannot be determined for points which do not align horizontally,
        /// vertically, or perfectly diagonally. For example, the points `(0, 0)` and `(1, 2)` do
        /// not share a common x or y coordinate *nor* can a line of slope `1` or `-1` be drawn
        /// between them.
        case pointsAreNotPerfectlyAligned
    }
}

/// Represents a line segment with a start, end, and perfectly aligned orientation between ponts.
public struct LineSegment {
    /// The start coordinate.
    public let start: Coordinate
    /// The end coordinate.
    public let end: Coordinate
    /// The orientation between the start and end coordinates.
    public let orientation: Orientation
    
    /// Format of supported string representations, as in the example `0,9 -> 5,9`.
    private static let stringRegex = try! NSRegularExpression(
        pattern: #"^(\d+),(\d+) -> (\d+),(\d+)$"#
    )
    
    /// Creates a new instance.
    ///
    /// The orientation between the start and end coordinates is determined via
    /// `Coordinate`.``Coordinate/relativeOrientation(to:)``. Any errors thrown by that method are
    /// propagated to the caller of this initializer.
    ///
    /// - Parameters:
    ///   - start: The start coordinate.
    ///   - end: The end coordinate.
    public init(from start: Coordinate, to end: Coordinate) throws {
        self.start = start
        self.end = end
        self.orientation = try start.relativeOrientation(to: end)
    }
    
    /// Creates a new instance.
    ///
    /// - Parameter string: A string in the format demonstrated in the example `0,9 -> 5,9`.
    public init(in string: String) throws {
        guard let match = LineSegment.stringRegex
                .firstMatch(in: string, range: NSRange(string.startIndex..., in: string)) else {
            throw ValidationError.stringDoesNotMatchSupportedFormat
        }
        
        let start = Coordinate(
            x: Int(string[Range(match.range(at: 1), in: string)!])!,
            y: Int(string[Range(match.range(at: 2), in: string)!])!
        )
        let end = Coordinate(
            x: Int(string[Range(match.range(at: 3), in: string)!])!,
            y: Int(string[Range(match.range(at: 4), in: string)!])!
        )
        
        try self.init(from: start, to: end)
    }
    
    /// Represents the errors that can be thrown while validating a line segment.
    public enum ValidationError: Error {
        /// A line segment string must match the format demonstrated in the example `0,9 -> 5,9`.
        case stringDoesNotMatchSupportedFormat
    }
}


