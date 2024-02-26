import XCTest

final class LexerErrorTests: BaseLexerTests {
    
    func test_unknown_keyword() {
        assert(
            source: "expecttt",
            throws: .unknownKeyword
        )
        
        assert(
            source: "randomkeyword",
            throws:  .unknownKeyword
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

    func test_broken_compund_tokens() {
        assert(
            source: "isselected",
            throws: .unknownKeyword
        )

        assert(
            source: "is NOT selected",
            throws: .unknownKeyword
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
