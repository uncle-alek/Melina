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

        assert(
            source: "subscenario",
            produce: [
                .init(
                    type: .subscenario,
                    lexeme: "subscenario"
                )
            ]
        )

        assert(
            source: "json",
            produce: [
                .init(
                    type: .json,
                    lexeme: "json"
                )
            ]
        )

        assert(
            source: "file",
            produce: [
                .init(
                    type: .file,
                    lexeme: "file"
                )
            ]
        )

        assert(
            source: "selected",
            produce: [
                .init(
                    type: .selected,
                    lexeme: "selected"
                )
            ]
        )

        assert(
            source: "exists",
            produce: [
                .init(
                    type: .exists,
                    lexeme: "exists"
                )
            ]
        )

        assert(
            source: "contains",
            produce: [
                .init(
                    type: .contains,
                    lexeme: "contains"
                )
            ]
        )

        assert(
            source: "with",
            produce: [
                .init(
                    type: .with,
                    lexeme: "with"
                )
            ]
        )
    }

    func test_compound_tokens() {

        assert(
            source: "not      selected",
            produce: [
                .init(
                    type: .notSelected,
                    lexeme: "not      selected"
                )
            ]
        )

        assert(
            source: "not selected",
            produce: [
                .init(
                    type: .notSelected,
                    lexeme: "not selected"
                )
            ]
        )

        assert(
            source: "not exists",
            produce: [
                .init(
                    type: .notExists,
                    lexeme: "not exists"
                )
            ]
        )

        assert(
            source: "tap button",
            produce: [
                .init(
                    type: .tap,
                    lexeme: "tap"
                ),
                .init(
                    type: .button,
                    lexeme: "button",
                    startOffset: 4,
                    endOffset: 10
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
                    lexeme: ":",
                    endOffset: 1
                )
            ]
        )
    }

    func test_suite() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button "Button_1"
                    end
                end
                """,
            produce: [
                .init(
                    type: .suite,
                    lexeme: "suite",
                    line: 1,
                    startOffset: 0,
                    endOffset: 5
                ),
                .init(
                    type: .string,
                    lexeme: "HomeScreen",
                    line: 1,
                    startOffset: 6,
                    endOffset: 18
                ),
                .init(
                    type: .colon,
                    lexeme: ":",
                    line: 1,
                    startOffset: 18,
                    endOffset: 19
                ),
                            .init(
                                type: .scenario,
                                lexeme: "scenario",
                                line: 2,
                                startOffset: 24,
                                endOffset: 32
                            ),
                            .init(
                                type: .string,
                                lexeme: "Open Home Screen",
                                line: 2,
                                startOffset: 33,
                                endOffset: 51
                            ),
                            .init(
                                type: .colon,
                                lexeme: ":",
                                line: 2,
                                startOffset: 51,
                                endOffset: 52
                            ),
                                        .init(
                                            type: .tap,
                                            lexeme: "tap",
                                            line: 3,
                                            startOffset: 61,
                                            endOffset: 64
                                        ),
                                        .init(
                                            type: .button,
                                            lexeme: "button",
                                            line: 3,
                                            startOffset: 65,
                                            endOffset: 71
                                        ),
                                        .init(
                                            type: .string,
                                            lexeme: "Button_1",
                                            line: 3,
                                            startOffset: 72,
                                            endOffset: 82
                                        ),
                            .init(
                                type: .end,
                                lexeme: "end",
                                line: 4,
                                startOffset: 87,
                                endOffset: 90
                            ),
                .init(
                    type: .end,
                    lexeme: "end",
                    line: 5,
                    startOffset: 91,
                    endOffset: 94
                )
            ]
        )
    }
}
