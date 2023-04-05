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
            let tokens = try Lexer(source: source).tokenize()
            let result = try Parser(tokens: tokens).parse()
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
        let tokens = try! Lexer(source: source).tokenize()
        XCTAssertThrowsError(try Parser(tokens: tokens).parse(), file: file, line: line) { e in
            let resultTestError = (e as! ParserError).toTestParserError(source: source)
            XCTAssertNoDifference(resultTestError, testError, file: file, line: line)
        }
    }
}

struct TestParserError: Equatable {
    
    let expected: ParserError.Expected
    let line: Int
    let offset: Int
    
    init(
        expected: ParserError.Expected,
        line: Int,
        offset: Int
    ) {
        self.expected = expected
        self.line = line
        self.offset = offset
    }
}

extension ParserError {
    
    func toTestParserError(
        source: String
    ) -> TestParserError {
        TestParserError(
            expected: expected,
            line: line,
            offset: source.distance(from: source.startIndex, to: index)
        )
    }
}
