import CustomDump
import XCTest

open class BaseParserTests: XCTestCase {
 
    func assert(
        source: String,
        produce program: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let result = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .get()
            let stringResult = ASTPrinter(program: result).toString()
            XCTAssertNoDifference(stringResult, program, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }

    func assert(
        source: String,
        throws error: ParserError.Expected,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .get()
            XCTFail("Expected error", file: file, line: line)
        } catch let errors as [Error] {
            XCTAssertEqual(errors.count, 1, "Expected single error", file: file, line: line)
            let testError = (errors.first as! ParserError)
            XCTAssertNoDifference(
                testError.expected,
                error,
                file: file,
                line: line
            )
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}
