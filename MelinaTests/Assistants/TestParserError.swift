struct TestParserError: Equatable {
    
    let expected: ParserError.Expected
    let line: Int
    let offset: Int
    
    init(
        expected: ParserError.Expected,
        line: Int,
        offset: Int
    ) {
        self.expected = expected
        self.line = line
        self.offset = offset
    }
    
    func toParserError(
        source: String
    ) -> ParserError {
        ParserError(
            expected: expected,
            line: line,
            index: source.index(by: offset)
        )
    }
}

extension ParserError {
    
    func toTestParserError(
        source: String
    ) -> TestParserError {
        TestParserError(
            expected: expected,
            line: line,
            offset: source.distance(from: source.startIndex, to: index)
        )
    }
}
