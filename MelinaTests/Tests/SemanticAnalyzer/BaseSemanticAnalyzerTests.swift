import CustomDump
import XCTest

open class BaseSemanticAnalyzerTests: XCTestCase {
    
    func assert(
        source: String,
        errors testErrors: [TestSemanticAnalyzerError],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0).analyze() }
                .get()
            XCTFail("Expected error")
        } catch let errors as [SemanticAnalyzerError] {
            let result = errors.map { $0.toTestSemanticAnalyzerError(source: source) }
            XCTAssertNoDifference(result, testErrors, file: file, line: line)
        } catch {
            XCTFail("Unexpected error type", file: file, line: line)
        }
    }
}
