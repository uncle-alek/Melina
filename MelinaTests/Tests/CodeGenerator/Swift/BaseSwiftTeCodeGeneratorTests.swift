import CustomDump
import XCTest

open class BaseSwiftTeCodeGeneratorTests: XCTestCase {

    func assert(
        source: String,
        produce code: SwiftTeCode,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let result = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SwiftTeCodeGenerator(program: $0).generate() }
                .get()
            XCTAssertNoDifference(result, code, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}
