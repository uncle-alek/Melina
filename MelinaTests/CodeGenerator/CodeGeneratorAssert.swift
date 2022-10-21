import CustomDump
import XCTest

func assert(
    source: String,
    produce code: Code,
    file: StaticString = #file,
    line: UInt = #line
) {
    do {
        let tokens = try Lexer(source: source).tokenize()
        let program = try Parser(tokens: tokens).parse()
        let result = try SwiftCodeGenerator(program: program).generate()
        XCTAssertNoDifference(result, code)
    } catch {
        XCTFail("Unexpected error: \(error)")
    }
}

func assert(
    source: String,
    throws error: SwiftCodeGeneratorError,
    file: StaticString = #file,
    line: UInt = #line
) {
    let tokens = try! Lexer(source: source).tokenize()
    let program = try! Parser(tokens: tokens).parse()
    XCTAssertThrowsError(try SwiftCodeGenerator(program: program).generate()) { e in
        XCTAssertNoDifference(e as! SwiftCodeGeneratorError, error)
    }
}

