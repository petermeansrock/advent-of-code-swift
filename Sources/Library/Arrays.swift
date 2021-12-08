import Foundation

extension Array where Element: Collection, Element.Index == Int {
    /// Returns a column of a row-major, multi-dimensional  array.
    /// - Parameter index: The zero-based index of the column to return.
    /// - Returns: A column of a row-major, multi-dimensional  array.
    func column(at index: Element.Index) -> [Element.Iterator.Element] {
        return self.map { $0[index] }
    }

    /// Returns the columns of a row-major, multi-dimensional  array.
    ///
    /// The number of columns returned is based off the number of elements in the first row of the
    /// multi-dimensional array. Effectively, this means that this method assumes that the first two
    /// dimensions of the multi-dimensional array are rectangular.
    /// - Returns: The columns of a row-major, multi-dimensional  array.
    func columns() -> [[Element.Iterator.Element]] {
        return (0..<self[0].count).map { self.column(at: $0) }
    }
}

/// A sequence of values separated by a stride, which itself can be zero (producing an infinite
/// sequence).
public struct StrideThroughToleratingZero: Sequence, IteratorProtocol {
    private var strideThroughIterator: StrideThroughIterator<Int>?
    private var unfoldSequence: UnfoldFirstSequence<Int>?

    internal init(from start: Int, through end: Int, by step: Int) {
        if step == 0 {
            self.unfoldSequence = sequence(first: start, next: { $0 }).makeIterator()
        } else {
            self.strideThroughIterator = stride(from: start, through: end, by: step).makeIterator()
        }
    }

    /// Returns the next element for this iterator.
    ///
    /// - Returns: The next element for this iterator.
    public mutating func next() -> Int? {
        if self.strideThroughIterator != nil {
            return self.strideThroughIterator!.next()
        } else {
            return self.unfoldSequence!.next()
        }
    }
}

/// Returns a sequence of values separated by a stride, which itself can be zero (producing an
/// infinite sequence).
///
/// - Parameters:
///   - start: The start of the sequence.
///   - end: The end of the sequence (assuming it can be reached).
///   - step: The stride between values in the sequence.
/// - Returns:Asequence of values separated by a stride, which itself can be zero (producing an
///   infinite sequence).
public func strideToleratingZero(from start: Int, through end: Int, by step: Int)
    -> StrideThroughToleratingZero
{
    return StrideThroughToleratingZero(from: start, through: end, by: step)
}
