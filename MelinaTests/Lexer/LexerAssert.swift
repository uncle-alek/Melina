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
        XCTAssertNoDifference(result, tokens + [.init(type: .eof, lexeme: "", line: 0)])
    } catch {
        XCTFail("Unexpected error: \(error)")
    }
}

func assert(
    source: String,
    throws error: LexerError,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertThrowsError(try Lexer(source: source).tokenize()) { e in
        XCTAssertNoDifference(e as! LexerError, error)
    }
}
