import Foundation

extension String {
    /// Returns all matches for a provided regular expression.
    ///
    /// - Parameter pattern: A regular expression.
    /// - Returns: All matches.
    /// - Throws: If the regular expression is invalid.
    public func matches(pattern: String) throws -> [RegexMatch] {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))

        var regexMatches = [RegexMatch]()
        for match in matches {
            // Convert NSRange to Range
            let range = Range(match.range, in: self)!

            // Convert capture groups
            var captureGroups = [CaptureGroup]()
            for i in 1..<match.numberOfRanges {
                let captureRange = Range(match.range(at: i), in: self)!
                captureGroups.append(
                    CaptureGroup(substring: self[captureRange], range: captureRange))
            }

            regexMatches.append(
                RegexMatch(substring: self[range], range: range, captureGroups: captureGroups))
        }

        return regexMatches
    }

    /// Returns the first match for a provided regular expression.
    ///
    /// - Parameter pattern: A regular expression.
    /// - Returns: The first match.
    /// - Throws: If the regular expression is invalid.
    public func firstMatch(pattern: String) throws -> RegexMatch? {
        let matches = try self.matches(pattern: pattern)
        return matches.isEmpty ? nil : matches.first
    }

    /// Returns the filastrst match for a provided regular expression.
    ///
    /// - Parameter pattern: A regular expression.
    /// - Returns: The last match.
    /// - Throws: If the regular expression is invalid.
    public func lastMatch(pattern: String) throws -> RegexMatch? {
        let matches = try self.matches(pattern: pattern)
        return matches.isEmpty ? nil : matches.last
    }

    /// Replaces the first match of a regular expression with a value from the provided transform.
    ///
    /// - Parameters:
    ///   - pattern: A regular expression.
    ///   - transform: Transforms the matched substring into its replacement string.
    /// - Returns: A new string after applying the replacement, or the original string if no match
    ///   was present.
    /// - Throws: If the regular expression is invalid.
    public func replaceFirstMatch(pattern: String, transform: (Substring) throws -> String) throws
        -> String
    {
        guard let match = try self.firstMatch(pattern: pattern) else {
            return self
        }

        return try self.replaceMatch(match: match, transform: transform)
    }

    /// Replaces the last match of a regular expression with a value from the provided transform.
    ///
    /// - Parameters:
    ///   - pattern: A regular expression.
    ///   - transform: Transforms the matched substring into its replacement string.
    /// - Returns: A new string after applying the replacement, or the original string if no match
    ///   was present.
    /// - Throws: If the regular expression is invalid.
    public func replaceLastMatch(pattern: String, transform: (Substring) throws -> String) throws
        -> String
    {
        guard let match = try self.lastMatch(pattern: pattern) else {
            return self
        }

        return try self.replaceMatch(match: match, transform: transform)
    }

    private func replaceMatch(match: RegexMatch, transform: (Substring) throws -> String) throws
        -> String
    {
        let beforeMatch = String(self[self.startIndex..<match.range.lowerBound])
        let afterMatch = String(self[match.range.upperBound..<self.endIndex])

        return beforeMatch + (try transform(match.substring)) + afterMatch
    }
}

/// The result of a successful regular expression match operation.
public struct RegexMatch {
    /// The substring matching the regular expression.
    public let substring: Substring
    /// The range of the matching substring within the original string.
    public let range: Range<String.Index>
    /// Any associated capture groups.
    public let captureGroups: [CaptureGroup]
}

/// A group captured from a regular expression match operation.
public struct CaptureGroup {
    /// The substring captured.
    public let substring: Substring
    /// The range of the captured substring within the original string.
    public let range: Range<String.Index>
}
