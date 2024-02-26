import XCTest

final class CompilerErrorReporterTests: BaseCompilerErrorReporterTests {

    func test_parser_error() {
        let source = """
            suite "Melina":
                scenario First scenario":
                    tap "Button_2" button
                end
            end
            """
        assert(
            source: source,
            fileName: "MelinaTests.swift",
            error: ParserError(expected: .scenarioName, line: 2, index: source.index(source.startIndex, offsetBy: 29)),
            errorMessage:
            """
            file: MelinaTests.swift line: 2 error: Scenario name missing. Specify the name for the scenario definition.
                scenario First scenario":
                         ^
            
            """
        )
    }
    
    func test_lexer_error() {
        let source = """
            suite "Melina" ~
                scenario First scenario":
                    tap "Button_2" button
                end
            end
            """
        assert(
            source: source,
            fileName: "MelinaTests.swift",
            error: LexerError(type: .unknownKeyword, line: 1, index: source.index(source.startIndex, offsetBy: 15)),
            errorMessage:
            """
            file: MelinaTests.swift line: 1 error: Unknown keyword.
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
            file: MelinaTests.swift line: 3 error: Action `tap` can't be applied to the element `label`.
                    tap label "Button_2"
                    ^
            
            """
        )
    }
}
