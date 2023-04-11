extension String {
    
    func index(by offset: Int) -> String.Index {
        var index = self.startIndex
        for _ in 0..<offset {
            index = self.index(after: index)
        }
        return index
    }
}
