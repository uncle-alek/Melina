struct TestLexerError: Equatable {
    
    let type: LexerError.`Type`
    let line: Int
    let offset: Int
    
    init(
        type: LexerError.`Type`,
        line: Int,
        offset: Int
    ) {
        self.type = type
        self.line = line
        self.offset = offset
    }
    
    func toLexerError(
        source: String
    ) -> LexerError {
        LexerError(
            type: type,
            line: line,
            index: source.index(by: offset)
        )
    }
}

extension LexerError {
    
    func toTestLexerError(
        source: String
    ) -> TestLexerError {
        TestLexerError(
            type: type,
            line: line,
            offset: source.distance(from: source.startIndex, to: index)
        )
    }
}

