import CustomDump
import XCTest

func assert(
    source: String,
    produce tokens: [Token],
    file: StaticString = #file,
    line: UInt = #line
) {
    do {
        let result = try Lexer(source: source).tokenize()
        XCTAssertNoDifference(result.last?.type, .eof)
        XCTAssertNoDifference(result.dropLast(), tokens, file: file, line: line)
    } catch {
        XCTFail("Unexpected error: \(error)", file: file, line: line)
    }
}

func assert(
    source: String,
    throws error: LexerError,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertThrowsError(try Lexer(source: source).tokenize(), file: file, line: line) { e in
        XCTAssertNoDifference(e as! LexerError, error, file: file, line: line)
    }
}
