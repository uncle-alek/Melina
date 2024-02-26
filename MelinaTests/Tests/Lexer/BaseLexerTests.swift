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
            let result = try Lexer(source: source).tokenize().get()
            let resultTestTokens = result.map { $0.toTestToken(source: source) }
            XCTAssertNoDifference(resultTestTokens.last?.type, .eof, file: file, line: line)
            XCTAssertNoDifference(resultTestTokens.dropLast(), testTokens, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
    
    func assert(
        source: String,
        throws testError: LexerError.`Type`,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _ = try Lexer(source: source).tokenize().get()
            XCTFail("Expected error", file: file, line: line)
        } catch let errors as [Error] {
            XCTAssertEqual(errors.count, 1, file: file, line: line)
            XCTAssertNoDifference((errors.first as! LexerError).type, testError, file: file, line: line)
        } catch {
            XCTFail("Unexpected error \(error)", file: file, line: line)
        }
    }
}
