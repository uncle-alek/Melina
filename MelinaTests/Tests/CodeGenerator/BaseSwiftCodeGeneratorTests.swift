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
            let result = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SwiftCodeGenerator(program: $0).generate() }
                .get()
            XCTAssertNoDifference(result, code, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}
