import XCTest

final class LexerFullTests: BaseLexerTests {
    
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
                    lexeme: "",
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
                                lexeme: "",
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
                                            startOffset: 78,
                                            endOffset: 88
                                        ),
                            .init(
                                type: .end,
                                lexeme: "end",
                                line: 4,
                                startOffset: 94,
                                endOffset: 97
                            ),
                .init(
                    type: .end,
                    lexeme: "end",
                    line: 5,
                    startOffset: 98,
                    endOffset: 101
                )
            ]
        )
    }
}
