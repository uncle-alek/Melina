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
            error: TestLexerError(type: .unknownKeyword, line: 1, offset: 15),
            errorMessage:
            """
            file: MelinaTests.swift line: 1 error: unknown keyword
            suite "Melina" ~
                           ^
            
            """
        )
    }
    
    func test_semantic_analyzer_error() {
          let source = """
            suite "Melina":
                scenario First scenario":
                    tap label "Button_2"
                end
            end
            """
        assert(
            source: source,
            fileName: "MelinaTests.swift",
            error: .incompatibleElement(
                action: Token(
                    type: .tap,
                    lexeme: "tap",
                    line: 3,
                    startIndex: source.index(source.startIndex, offsetBy: 54),
                    endIndex: source.index(source.startIndex, offsetBy: 57)
                ),
                element: Token(
                    type: .label,
                    lexeme: "label",
                    line: 3,
                    startIndex: source.index(source.startIndex, offsetBy: 70),
                    endIndex: source.index(source.startIndex, offsetBy: 74)
                )
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
