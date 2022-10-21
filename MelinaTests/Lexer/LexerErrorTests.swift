import XCTest

final class LexerErrorTests: XCTestCase {
    
    func test_unknown_keyword() {
        assert(
            source: "expecttt",
            throws: .unknowKeyword
        )
        
        assert(
            source: "randomkeyword",
            throws: .unknowKeyword
        )
    }
    
    func test_broken_comment() {
        assert(
            source: "/ This is comment",
            throws: .secondSlashRequiredForComment
        )
    }
    
    func test_unknown_symbol() {
        assert(
            source: "?",
            throws: .unknownSymbol
        )
        
        assert(
            source: "end ;",
            throws: .unknownSymbol
        )
    }
    
    func test_new_line_in_string_literal() {
        assert(
            source:
            """
                "Hello
                World"
            """,
            throws: .newLineInStringLiteral
        )
    }
}
