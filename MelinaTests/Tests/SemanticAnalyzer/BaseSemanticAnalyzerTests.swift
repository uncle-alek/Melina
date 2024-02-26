import CustomDump
import XCTest

open class BaseSemanticAnalyzerTests: XCTestCase {
    
    func assert(
        source: String,
        errors testErrors: [SemanticAnalyzerError.ErrorType],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0).analyze() }
                .get()
            XCTFail("Expected error", file: file, line: line)
        } catch let errors as [SemanticAnalyzerError] {
            let errorTypes = errors.map { $0.type }
            XCTAssertNoDifference(errorTypes, testErrors, file: file, line: line)
        } catch {
            XCTFail("Unexpected error type", file: file, line: line)
        }
    }

    func assertNoError(
        source: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0).analyze() }
                .get()
        } catch {
            XCTFail("Unexpected error", file: file, line: line)
        }
    }
}
