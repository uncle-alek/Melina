import XCTest

final class CompilerErrorReporterTests: BaseCompilerErrorReporterTests {
    
    func test_parser_error() {
        assert(
            source:
            """
            suite "Melina":
                scenario First scenario":
                    tap "Button_2" button
                end
            end
            """,
            fileName: "MelinaTests.swift",
            error: TestParserError(expected: .scenarioName, line: 2, offset: 29),
            errorMessage:
            """
            file: MelinaTests.swift line: 2 error: expected name in scenario declaration
                scenario First scenario":
                         ^
            
            """
        )
    }
    
    func test_lexer_error() {
        assert(
            source:
            """
            suite "Melina" ~
                scenario First scenario":
                    tap "Button_2" button
                end
            end
            """,
            fileName: "MelinaTests.swift",
            error: TestLexerError(type: .unknowKeyword, line: 1, offset: 15),
            errorMessage:
            """
            file: MelinaTests.swift line: 1 error: unknown keyword
            suite "Melina" ~
                           ^
            
            """
        )
    }
    
    func test_semantic_analyzer_error() {
        assert(
            source:
            """
            suite "Melina":
                scenario First scenario":
                    tap "Button_2" text
                end
            end
            """,
            fileName: "MelinaTests.swift",
            error: TestSemanticAnalyzerError.incompatibleAction(
                action: TestToken(type: .tap, lexeme: "tap", line: 3, startOffset: 54, endOffset: 57),
                element: TestToken(type: .text, lexeme: "text", line: 3, startOffset: 70, endOffset: 74)
            ),
            errorMessage:
            """
            file: MelinaTests.swift line: 3 error: action `tap` can't be applied to the element `text`
                    tap "Button_2" text
                    ^
            
            """
        )
    }
}
