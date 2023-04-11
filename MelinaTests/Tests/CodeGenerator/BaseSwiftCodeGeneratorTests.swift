import CustomDump
import XCTest

open class BaseSwiftCodeGeneratorTests: XCTestCase {
    
    func assert(
        source: String,
        produce code: Code,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let tokens = try Lexer(source: source).tokenize()
            let program = try Parser(tokens: tokens).parse()
            let result = SwiftCodeGenerator(program: program).generate()
            XCTAssertNoDifference(result, code, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}
