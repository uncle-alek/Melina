import XCTest

final class LexerTests: BaseLexerTests {
    
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
                    lexeme: "suite"
                )
            ]
        )
        
        assert(
            source: "scenario",
            produce: [
                .init(
                    type: .scenario,
                    lexeme: "scenario"
                )
            ]
        )

        assert(
            source: "arguments",
            produce: [
                .init(
                    type: .arguments,
                    lexeme: "arguments"
                )
            ]
        )

        assert(
            source: "end",
            produce: [
                .init(
                    type: .end,
                    lexeme: "end"
                )
            ]
        )

        assert(
            source: "tap",
            produce: [
                .init(
                    type: .tap,
                    lexeme: "tap"
                )
            ]
        )

        assert(
            source: "verify",
            produce: [
                .init(
                    type: .verify,
                    lexeme: "verify"
                )
            ]
        )

        assert(
            source: "scrollUp",
            produce: [
                .init(
                    type: .scrollUp,
                    lexeme: "scrollUp"
                )
            ]
        )

        assert(
            source: "scrollDown",
            produce: [
                .init(
                    type: .scrollDown,
                    lexeme: "scrollDown"
                )
            ]
        )

        assert(
            source: "button",
            produce: [
                .init(
                    type: .button,
                    lexeme: "button"
                )
            ]
        )

        assert(
            source: "text",
            produce: [
                .init(
                    type: .text,
                    lexeme: "text"
                )
            ]
        )

        assert(
            source: "searchField",
            produce: [
                .init(
                    type: .searchField,
                    lexeme: "searchField"
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
                    lexeme: "12345"
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
                    endOffset: 13
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
                    endOffset: 1
                )
            ]
        )
    }
}
