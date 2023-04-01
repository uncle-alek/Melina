import CustomDump
import XCTest

func assert(
    source: String,
    produce program: Program,
    file: StaticString = #file,
    line: UInt = #line
) {
    do {
        let tokens = try Lexer(source: source).tokenize()
        let result = try Parser(tokens: tokens).parse()
        XCTAssertNoDifference(result, program, file: file, line: line)
    } catch {
        XCTFail("Unexpected error: \(error)")
    }
}

func assert(
    source: String,
    throws error: ParserError,
    file: StaticString = #file,
    line: UInt = #line
) {
    let tokens = try! Lexer(source: source).tokenize()
    XCTAssertThrowsError(try Parser(tokens: tokens).parse(), file: file, line: line) { e in
        XCTAssertNoDifference(e as! ParserError, error, file: file, line: line)
    }
}
