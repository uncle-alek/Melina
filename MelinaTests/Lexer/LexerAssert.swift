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
        XCTFail("Expected no error")
    }
}
