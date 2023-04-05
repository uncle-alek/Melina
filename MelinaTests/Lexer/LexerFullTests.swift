import XCTest

final class LexerFullTests: BaseLexerTests {
    
    func test_suite() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        scrollDown "homeScreenIdentifier" searchField
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
                                            type: .scrollDown,
                                            lexeme: "scrollDown",
                                            line: 3,
                                            startOffset: 61,
                                            endOffset: 71
                                        ),
                                        .init(
                                            type: .string,
                                            lexeme: "homeScreenIdentifier",
                                            line: 3,
                                            startOffset: 72,
                                            endOffset: 94
                                        ),
                                        .init(
                                            type: .searchField,
                                            lexeme: "searchField",
                                            line: 3,
                                            startOffset: 95,
                                            endOffset: 106
                                        ),
                            .init(
                                type: .end,
                                lexeme: "end",
                                line: 4,
                                startOffset: 111,
                                endOffset: 114
                            ),
                .init(
                    type: .end,
                    lexeme: "end",
                    line: 5,
                    startOffset: 115,
                    endOffset: 118
                )
            ]
        )
    }
}
