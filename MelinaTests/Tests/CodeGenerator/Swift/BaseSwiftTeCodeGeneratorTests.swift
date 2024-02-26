import CustomDump
import XCTest

open class BaseSwiftTeCodeGeneratorTests: XCTestCase {

    func assert(
        source: String,
        fileName: String,
        code: SwiftTeCode,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let result = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { CodeGenerator(program: $0, SwiftTeCodeBuilder()).generate() }
                .get()
            XCTAssertNoDifference(
                JSONSerializer.deserialize(result.content),
                code.commands,
                file: file,
                line: line
            )
            XCTAssertNoDifference(
                result.name,
                fileName,
                file: file,
                line: line
            )
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}
