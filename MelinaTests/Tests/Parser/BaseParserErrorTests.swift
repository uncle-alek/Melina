import CustomDump
import XCTest

open class BaseParserErrorTests: XCTestCase {
 
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
        throws testError: TestParserError,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _ = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .get()
        } catch let errors as [Error] {
            XCTAssertEqual(errors.count, 1, file: file, line: line)
            XCTAssertNoDifference((errors.first as! ParserError).toTestParserError(source: source), testError, file: file, line: line)
        } catch {
            XCTFail("Unexpected error type", file: file, line: line)
        }
    }
}
