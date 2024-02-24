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
            source: "edit",
            produce: [
                .init(
                    type: .edit,
                    lexeme: "edit"
                )
            ]
        )

        assert(
            source: "to",
            produce: [
                .init(
                    type: .to,
                    lexeme: "to"
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
            source: "textfield",
            produce: [
                .init(
                    type: .textField,
                    lexeme: "textfield"
                )
            ]
        )

        assert(
            source: "label",
            produce: [
                .init(
                    type: .label,
                    lexeme: "label"
                )
            ]
        )

        assert(
            source: "view",
            produce: [
                .init(
                    type: .view,
                    lexeme: "view"
                )
            ]
        )
    }

    func test_compound_tokens() {
        assert(
            source: "is selected",
            produce: [
                .init(
                    type: .isSelected,
                    lexeme: "is selected"
                )
            ]
        )

        assert(
            source: "is    selected",
            produce: [
                .init(
                    type: .isSelected,
                    lexeme: "is    selected"
                )
            ]
        )

        assert(
            source: "is not selected",
            produce: [
                .init(
                    type: .isNotSelected,
                    lexeme: "is not selected"
                )
            ]
        )

        assert(
            source: "is exist",
            produce: [
                .init(
                    type: .isExist,
                    lexeme: "is exist"
                )
            ]
        )

        assert(
            source: "is not exist",
            produce: [
                .init(
                    type: .isNotExist,
                    lexeme: "is not exist"
                )
            ]
        )

        assert(
            source: "contains value",
            produce: [
                .init(
                    type: .containsValue,
                    lexeme: "contains value"
                )
            ]
        )

        assert(
            source: "with text",
            produce: [
                .init(
                    type: .withText,
                    lexeme: "with text"
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

    func test_special_symbols() {
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
