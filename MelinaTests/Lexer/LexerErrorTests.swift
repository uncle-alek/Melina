import XCTest

final class LexerErrorTests: BaseLexerTests {
    
    func test_unknown_keyword() {
        assert(
            source: "expecttt",
            throws: .init(type: .unknowKeyword, line: 1, offset: 8)
        )
        
        assert(
            source: "randomkeyword",
            throws:  .init(type: .unknowKeyword, line: 1, offset: 13)
        )
    }
    
    func test_broken_comment() {
        assert(
            source: "/ This is comment",
            throws: .init(type: .secondSlashRequiredForComment, line: 1, offset: 2)
        )
    }
    
    func test_unknown_symbol() {
        assert(
            source: "?",
            throws: .init(type: .unknownSymbol, line: 1, offset: 1)
        )
        
        assert(
            source: "end ;",
            throws: .init(type: .unknownSymbol, line: 1, offset: 5)
        )
    }
    
    func test_new_line_in_string_literal() {
        assert(
            source:
            """
                "Hello
                World"
            """,
            throws: .init(type: .newLineInStringLiteral, line: 1, offset: 11)
        )
    }
}
