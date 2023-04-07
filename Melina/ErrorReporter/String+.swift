import Foundation

extension String {
    
    func line(_ startIndex: String.Index, _ endIndex: String.Index) -> String {
        String(self[lineStartIndex(startIndex)...lineEndIndex(endIndex)])
    }
    
    func offset(_ startIndex: String.Index) -> Int {
        self[lineStartIndex(startIndex)..<startIndex].count
    }
}

private extension String {
    
    func lineStartIndex(_ anchorIndex: String.Index) -> String.Index {
        var lineStartIndex = anchorIndex
        var currentChar = self[lineStartIndex]
        while currentChar != "\n" {
            lineStartIndex = self.index(before: lineStartIndex)
            currentChar = self[lineStartIndex]
        }
        return self.index(after: lineStartIndex)
    }
    
    func lineEndIndex(_ anchorIndex: String.Index) -> String.Index {
        var lineEndIndex = anchorIndex
        var currentChar = self[lineEndIndex]
        while currentChar != "\n" {
            lineEndIndex = self.index(after: lineEndIndex)
            currentChar = self[lineEndIndex]
        }
        return self.index(before: lineEndIndex)
    }
}
