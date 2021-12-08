import Foundation

/// Represents an input file for Advent of Code.
public struct InputFile {
    private let url: URL

    /// Creates an instance.
    ///
    /// - Parameter day: The day number for the input file.
    @available(macOS 10.12, *)
    public init(day: Int) {
        self.url = NSURL.fileURL(
            withPath: Bundle.module.path(forResource: "\(day)", ofType: "txt")!)
    }

    /// Loads the contents of the file into a string.
    ///
    /// - Returns: The contents of the file as a string.
    public func loadContents() -> String {
        return (try? String(contentsOf: self.url, encoding: .utf8))!
    }

    /// Loads the contents of the file into an array of strings, one for each line of the file.
    /// - Returns: The contents of the file into an array of strings, one for each line of the file.
    public func loadLines() -> [String] {
        return self.loadContents().components(separatedBy: .newlines).compactMap { $0 }
    }
}
