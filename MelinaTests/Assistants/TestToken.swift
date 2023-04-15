struct TestToken: Equatable {
    
    let type: TokenType
    let lexeme: String
    let line: Int
    let startOffset: Int
    let endOffset: Int
    
    init(
        type: TokenType,
        lexeme: String,
        line: Int = 1,
        startOffset: Int = 0,
        endOffset: Int? = nil
    ) {
        self.type = type
        self.lexeme = lexeme
        self.line = line
        self.startOffset = startOffset
        self.endOffset = endOffset ?? lexeme.count
    }
    
    func toToken(
        source: String
    ) -> Token {
        Token(
            type: type,
            lexeme: lexeme,
            line: line,
            startIndex: source.index(by: startOffset),
            endIndex: source.index(by: endOffset)
        )
    }
}

extension Token {
    
    func toTestToken(
        source: String
    ) -> TestToken {
        TestToken(
            type: type,
            lexeme: lexeme,
            line: line,
            startOffset: source.distance(from: source.startIndex, to: startIndex),
            endOffset: source.distance(from: source.startIndex, to: endIndex)
        )
    }
}
