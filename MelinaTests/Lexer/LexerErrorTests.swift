import XCTest

final class LexerErrorTests: BaseLexerTests {
    
    func test_unknown_keyword() {
        assert(
            source: "expecttt",
            throws: LexerError(type: .unknowKeyword, line: 1)
        )
        
        assert(
            source: "randomkeyword",
            throws:  LexerError(type: .unknowKeyword, line: 1)
        )
    }
    
    func test_broken_comment() {
        assert(
            source: "/ This is comment",
            throws: LexerError(type: .secondSlashRequiredForComment, line: 1)
        )
    }
    
    func test_unknown_symbol() {
        assert(
            source: "?",
            throws: LexerError(type: .unknownSymbol, line: 1)
        )
        
        assert(
            source: "end ;",
            throws: LexerError(type: .unknownSymbol, line: 1)
        )
    }
    
    func test_new_line_in_string_literal() {
        assert(
            source:
            """
                "Hello
                World"
            """,
            throws: LexerError(type: .newLineInStringLiteral, line: 1)
        )
    }
}
