import CustomDump
import XCTest

open class BaseCompilerErrorReporterTests: XCTestCase {
    
    func assert(
        source: String,
        fileName: String,
        error: LexerError,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assert(
            source: source,
            fileName: fileName,
            errors: [error],
            errorMessage: errorMessage,
            file: file,
            line: line
        )
    }
    
    func assert(
        source: String,
        fileName: String,
        error: ParserError,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assert(
            source: source,
            fileName: fileName,
            errors: [error],
            errorMessage: errorMessage,
            file: file,
            line: line
        )
    }
    
    func assert(
        source: String,
        fileName: String,
        error: SemanticAnalyzerError,
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assert(
            source: source,
            fileName: fileName,
            errors: [error],
            errorMessage: errorMessage,
            file: file,
            line: line
        )
    }
    
    private func assert(
        source: String,
        fileName: String,
        errors: [Error],
        errorMessage: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var result: String = ""
        let reporter = CompilerErrorReporter(filePath: fileName, source: source, print: { result = $0 })
        reporter.report(errors: errors)
        XCTAssertNoDifference(result, errorMessage, file: file, line: line)
    }
}
