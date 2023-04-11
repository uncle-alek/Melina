import CustomDump
import XCTest

open class BaseLexerTests: XCTestCase {
   
    func assert(
        source: String,
        produce testTokens: [TestToken],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let result = try Lexer(source: source).tokenize()
            let resultTestTokens = result.map { $0.toTestToken(source: source) }
            XCTAssertNoDifference(resultTestTokens.last?.type, .eof, file: file, line: line)
            XCTAssertNoDifference(resultTestTokens.dropLast(), testTokens, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
    
    func assert(
        source: String,
        throws testError: TestLexerError,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try Lexer(source: source).tokenize(), file: file, line: line) { e in
            let resultTestError = (e as! LexerError).toTestLexerError(source: source)
            XCTAssertNoDifference(resultTestError, testError, file: file, line: line)
        }
    }
}
