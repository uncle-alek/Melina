import CustomDump
import XCTest

open class BaseErrorReporterTests: XCTestCase {
    
    func assert(
        source: String,
        fileName: String,
        error: TestLexerError,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assert(
            source: source,
            fileName: fileName,
            error: error.toLexerError(source: source),
            errorMessage: errorMessage,
            file: file,
            line: line
        )
    }
    
    func assert(
        source: String,
        fileName: String,
        error: TestParserError,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assert(
            source: source,
            fileName: fileName,
            error: error.toParserError(source: source),
            errorMessage: errorMessage,
            file: file,
            line: line
        )
    }
    
    func assert(
        error: FileServiceError,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assert(
            source: "",
            fileName: "Melina.swift",
            error: error,
            errorMessage: errorMessage,
            file: file,
            line: line
        )
    }
    
    private func assert(
        source: String,
        fileName: String,
        error: Error,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var result: String = ""
        let reporter = ErrorReporter(filePath: fileName, source: source, print: { result = $0 })
        reporter.report(error: error)
        XCTAssertNoDifference(result, errorMessage, file: file, line: line)
    }
}
