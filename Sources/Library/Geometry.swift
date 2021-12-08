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
    
    /// Returns a list of coordinates between the two provided coordinates, inclusive.
    /// - Returns: A list of coordinates between the two provided coordinates, inclusive.
    public static func ... (lhs: Coordinate, rhs: Coordinate) throws -> [Coordinate] {
        let orientation = try lhs.relativeOrientation(to: rhs)
        
        var dx: Int
        var dy: Int
        switch (orientation) {
        case .horizontal:
            dx = lhs.x < rhs.x ? 1 : -1
            dy = 0
        case .vertical:
            dx = 0
            dy = lhs.y < rhs.y ? 1 : -1
        case .diagonal:
            dx = lhs.x < rhs.x ? 1 : -1
            dy = lhs.y < rhs.y ? 1 : -1
        }
        
        var coordinates = [Coordinate]()
        var current = lhs
        while (current != rhs) {
            coordinates.append(current)
            current = Coordinate(x: current.x + dx, y: current.y + dy)
        }
        coordinates.append(rhs)
        
        return coordinates
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

/// Represents a graphed set of line segments accounting for overlapping segments.
///
/// Consider the following set of line segments (processable by
/// `LineSegment`.``LineSegment/init(in:)``):
///
/// ```
/// 0,9 -> 5,9
/// 8,0 -> 0,8
/// 9,4 -> 3,4
/// 2,2 -> 2,1
/// 7,0 -> 7,4
/// 6,4 -> 2,0
/// 0,9 -> 2,9
/// 3,4 -> 1,4
/// 0,0 -> 8,8
/// 5,5 -> 8,2
/// ```
///
/// The above segments will be logically plotted as follows. Each number represents the number of
/// line segments which overlap at each ``Coordinate``.
///
/// ```
/// .......1..
/// ..1....1..
/// ..1....1..
/// .......1..
/// .112111211
/// ..........
/// ..........
/// ..........
/// ..........
/// 222111....
/// ```
public struct Plot {
    public private(set) var grid: [[Int]]
    
    /// Creates a new instance.
    /// 
    /// - Parameters:
    ///   - maxX: maximum supported x-coordinate
    ///   - maxY: maximum supported y-coordinate
    public init(maxX: Int, maxY: Int) {
        self.grid = Array(repeating: Array(repeating: 0, count: maxX + 1), count: maxY + 1)
    }
    
    /// Plots the provided line segment.
    ///
    /// - Parameter line: The line segment to plot.
    public mutating func plot(line: LineSegment) {
        for coordinate in try! line.start...line.end {
            self.grid[coordinate.y][coordinate.x] += 1
        }
    }
}
