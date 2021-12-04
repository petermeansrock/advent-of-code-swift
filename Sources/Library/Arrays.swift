import Foundation

extension Array where Element: Collection, Element.Index == Int {
    /// Returns a column of a row-major, multi-dimensional  array.
    /// - Parameter index: The zero-based index of the column to return.
    /// - Returns: A column of a row-major, multi-dimensional  array.
    func column(at index: Element.Index) -> [Element.Iterator.Element] {
        return self.map{ $0[index] }
    }
    
    /// Returns the columns of a row-major, multi-dimensional  array.
    ///
    /// The number of columns returned is based off the number of elements in the first row of the
    /// multi-dimensional array. Effectively, this means that this method assumes that the first two
    /// dimensions of the multi-dimensional array are rectangular.
    /// - Returns: The columns of a row-major, multi-dimensional  array.
    func columns() -> [[Element.Iterator.Element]] {
        return (0..<self[0].count).map{ self.column(at: $0) }
    }
}
