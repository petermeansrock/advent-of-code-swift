import Foundation

public struct InputFile {
    private let url: URL
    
    @available(macOS 10.12, *)
    public init(day: Int) {
        self.url = NSURL.fileURL(withPath: Bundle.module.path(forResource: "\(day)", ofType: "txt")!)
    }
    
    public func loadContents() -> String {
        return (try? String(contentsOf: self.url, encoding: .utf8))!
    }
    
    public func loadLines() -> [String] {
        return self.loadContents().components(separatedBy: .newlines).compactMap{ $0 }
    }
}
