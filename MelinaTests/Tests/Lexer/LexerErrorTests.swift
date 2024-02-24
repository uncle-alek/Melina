import XCTest

final class LexerErrorTests: BaseLexerTests {
    
    func test_unknown_keyword() {
        assert(
            source: "expecttt",
            throws: TestLexerError(type: .unknownKeyword, line: 1, offset: 7)
        )
        
        assert(
            source: "randomkeyword",
            throws:  TestLexerError(type: .unknownKeyword, line: 1, offset: 12)
        )
    }
    
    func test_broken_comment() {
        assert(
            source: "/ This is comment",
            throws: TestLexerError(type: .secondSlashRequiredForComment, line: 1, offset: 1)
        )
    }
    
    func test_unknown_symbol() {
        assert(
            source: "?",
            throws: TestLexerError(type: .unknownSymbol, line: 1, offset: 0)
        )
        
        assert(
            source: "end ;",
            throws: TestLexerError(type: .unknownSymbol, line: 1, offset: 4)
        )
    }

    func test_broken_compund_tokens() {
        assert(
            source: "isselected",
            throws: TestLexerError(type: .unknownKeyword, line: 1, offset: 9)
        )

        assert(
            source: "is NOT selected",
            throws: TestLexerError(type: .unknownKeyword, line: 1, offset: 14)
        )
    }

    func test_new_line_in_string_literal() {
        assert(
            source:
            """
                "Hello
                World"
            """,
            throws: TestLexerError(type: .newLineInStringLiteral, line: 1, offset: 10)
        )
    }
}
