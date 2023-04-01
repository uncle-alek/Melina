import XCTest

final class LexerFullTests: XCTestCase {
    
    func test_suite() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            scrollDown "homeScreenIdentifier" searchField
                            tap "loginButton" button
                            verify "loginScreenIdentifier" text
                        end
                    end
                """,
            produce: [
                .init(
                    type: .suite,
                    lexeme: "suite",
                    line: 1
                ),
                .init(
                    type: .string,
                    lexeme: "HomeScreen",
                    line: 1
                ),
                .init(
                    type: .colon,
                    lexeme: "",
                    line: 1
                ),
                            .init(
                                type: .scenario,
                                lexeme: "scenario",
                                line: 2
                            ),
                            .init(
                                type: .string,
                                lexeme: "Open Home Screen",
                                line: 2
                            ),
                            .init(
                                type: .colon,
                                lexeme: "",
                                line: 2
                            ),
                                        .init(
                                            type: .scrollDown,
                                            lexeme: "scrollDown",
                                            line: 3
                                        ),
                                        .init(
                                            type: .string,
                                            lexeme: "homeScreenIdentifier",
                                            line: 3
                                        ),
                                        .init(
                                            type: .searchField,
                                            lexeme: "searchField",
                                            line: 3
                                        ),
                                        .init(
                                            type: .tap,
                                            lexeme: "tap",
                                            line: 4
                                        ),
                                        .init(
                                            type: .string,
                                            lexeme: "loginButton",
                                            line: 4
                                        ),
                                        .init(
                                            type: .button,
                                            lexeme: "button",
                                            line: 4
                                        ),
                                        .init(
                                            type: .verify,
                                            lexeme: "verify",
                                            line: 5
                                        ),
                                        .init(
                                            type: .string,
                                            lexeme: "loginScreenIdentifier",
                                            line: 5
                                        ),
                                        .init(
                                            type: .text,
                                            lexeme: "text",
                                            line: 5
                                        ),
                            .init(
                                type: .end,
                                lexeme: "end",
                                line: 6
                            ),
                .init(
                    type: .end,
                    lexeme: "end",
                    line: 7
                )
            ]
        )
    }
}
