import Foundation

open class MelinaString {
    
    fileprivate init() {}
    
    static func create(with string: String) -> MelinaString {
        if string.isEmpty {
            return MelinaEmptyString()
        } else {
            return MelinaNonEmptyString(string: string)
        }
    }
    
    func textLine(_ startIndex: String.Index, _ endIndex: String.Index) -> String {
        fatalError("Method should be overriden")
    }
    
    func offset(_ index: String.Index) -> Int {
        fatalError("Method should be overriden")
    }
}

private final class MelinaNonEmptyString: MelinaString {
    
    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    override func textLine(_ startIndex: String.Index, _ endIndex: String.Index) -> String {
        self.trimmedSubstring(lineStartIndex(startIndex)...lineEndIndex(endIndex))
    }
    
    override func offset(_ index: String.Index) -> Int {
        self.trimmedSubstring(lineStartIndex(index)..<index).count
    }
    
    func trimmedSubstring(_ range: ClosedRange<String.Index>) -> String {
        self.trimNewLine(self.string[range])
    }
    
    func trimmedSubstring(_ range: Range<String.Index>) -> String {
        self.trimNewLine(self.string[range])
    }
    
    func trimNewLine<T: StringProtocol>(_ string: T) -> String {
        string.trimmingCharacters(in: CharacterSet(arrayLiteral: "\n"))
    }
    
    func lineStartIndex(_ anchorIndex: String.Index) -> String.Index {
        var lineStartIndex = anchorIndex
        var currentChar = self.string[lineStartIndex]
        while currentChar != "\n" && lineStartIndex != self.string.startIndex {
            lineStartIndex = self.string.index(before: lineStartIndex)
            currentChar = self.string[lineStartIndex]
        }
        return lineStartIndex
    }
    
    func lineEndIndex(_ anchorIndex: String.Index) -> String.Index {
        var lineEndIndex = anchorIndex
        var currentChar = self.string[lineEndIndex]
        while currentChar != "\n" && lineEndIndex != self.string.index(before: self.string.endIndex) {
            lineEndIndex = self.string.index(after: lineEndIndex)
            currentChar = self.string[lineEndIndex]
        }
        return lineEndIndex
    }
}

private final class MelinaEmptyString: MelinaString {
        
    override func textLine(_ startIndex: String.Index, _ endIndex: String.Index) -> String {
        ""
    }
    
    override func offset(_ startIndex: String.Index) -> Int {
        0
    }
}
