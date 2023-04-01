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
            source: "arguments",
            produce: [
                .init(
                    type: .arguments,
                    lexeme: "arguments",
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
            source: "verify",
            produce: [
                .init(
                    type: .verify,
                    lexeme: "verify",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "scrollUp",
            produce: [
                .init(
                    type: .scrollUp,
                    lexeme: "scrollUp",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "scrollDown",
            produce: [
                .init(
                    type: .scrollDown,
                    lexeme: "scrollDown",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "button",
            produce: [
                .init(
                    type: .button,
                    lexeme: "button",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "text",
            produce: [
                .init(
                    type: .text,
                    lexeme: "text",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "searchField",
            produce: [
                .init(
                    type: .searchField,
                    lexeme: "searchField",
                    line: 1
                )
            ]
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
                    lexeme: "Hello world",
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
}
