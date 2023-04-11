import XCTest

final class ErrorReporterTests: BaseErrorReporterTests {
    
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
    
    func test_file_service_error() {
        assert(
            error: FileServiceError(type: .fileIsNotExist, filePath: "User/my_user/MelinaTests.swift"),
            errorMessage:
            """
            error: file does not exist at path: User/my_user/MelinaTests.swift
            
            """
        )
    }
}