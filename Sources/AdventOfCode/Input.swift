import Foundation

/// Represents an input file for Advent of Code.
public struct InputFile {
    private let url: URL

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - bundle: The bundle from which to load the input file.
    ///   - day: The day number for the input file.
    @available(macOS 10.12, *)
    public init(bundle: Bundle, day: Int) {
        self.url = NSURL.fileURL(
            withPath: bundle.path(forResource: "\(day)", ofType: "txt")!)
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

    /// Loads the contents of the file into chunks of lines.
    ///
    /// Each chunk is delimited by an empty line. Consider the following input file:
    ///
    /// ```
    /// one
    /// chunk
    ///
    /// another
    /// chunk
    ///
    ///
    /// ```
    ///
    /// The above input would produce two chunks, each comprised of two lines:
    /// - Chunk 1 would contain `["one", "chunk"]`
    /// - Chunk 2 would contain `["another", "chunk"]`
    ///
    /// - Returns: The chunks of lines from the input file.
    public func loadLineChunks() -> [[String]] {
        let lines = loadLines()
        var chunks = [[String]]()
        var chunk = [String]()
        for line in lines {
            if line.count == 0 {
                // On blank lines, record previous chunk and create a new one
                chunks.append(chunk)
                chunk = []
            } else {
                // Otherwise, record line as part of current chunk
                chunk.append(line)
            }
        }

        return chunks
    }
}
