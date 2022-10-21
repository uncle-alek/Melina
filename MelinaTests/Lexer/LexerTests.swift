import XCTest

final class LexerTests: XCTestCase {
    
    func test_empty_source() {
        assert(
            source: "",
            produce: []
        )
    }
    
    func test_keyword() {
        assert(
            source: "suite",
            produce: [
                .init(
                    type: .suite,
                    lexeme: "suite",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "scenario",
            produce: [
                .init(
                    type: .scenario,
                    lexeme: "scenario",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "end",
            produce: [
                .init(
                    type: .end,
                    lexeme: "end",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "open",
            produce: [
                .init(
                    type: .open,
                    lexeme: "open",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "tap",
            produce: [
                .init(
                    type: .tap,
                    lexeme: "tap",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "expect",
            produce: [
                .init(
                    type: .expect,
                    lexeme: "expect",
                    line: 1
                )
            ]
        )
    }
    
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
    
    func test_number() {
        assert(
            source: "12345",
            produce: [
                .init(
                    type: .number,
                    lexeme: "12345",
                    line: 1
                )
            ]
        )
    }
    
    func test_string() {
        assert(
            source: "\"Hello world\"",
            produce: [
                .init(
                    type: .string,
                    lexeme: "\"Hello world\"",
                    line: 1
                )
            ]
        )
    }
    
    func test_comment() {
        assert(
            source: "// This is comment",
            produce: []
        )
    }
    
    func test_broken_comment() {
        assert(
            source: "/ This is comment",
            throws: .secondSlashRequiredForComment
        )
    }
    
    func test_colon() {
        assert(
            source: ":",
            produce: [
                .init(
                    type: .colon,
                    lexeme: "",
                    line: 1
                )
            ]
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
}
