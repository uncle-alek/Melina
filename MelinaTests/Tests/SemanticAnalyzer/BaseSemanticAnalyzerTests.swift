import CustomDump
import XCTest

open class BaseSemanticAnalyzerTests: XCTestCase {
    
    func assert(
        source: String,
        errors testErrors: [SemanticAnalyzerError.ErrorType],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let stub = SemanticAnalyzerFileServiceStub()
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0, JsonTable(), stub).analyze() }
                .get()
            XCTFail("Expected error", file: file, line: line)
        } catch let errors as [SemanticAnalyzerError] {
            let errorTypes = errors.map { $0.type }
            XCTAssertNoDifference(errorTypes, testErrors, file: file, line: line)
        } catch {
            XCTFail("Unexpected error \(error)", file: file, line: line)
        }
    }

    func assertNoError(
        source: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let stub = SemanticAnalyzerFileServiceStub()
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0, JsonTable(), stub).analyze() }
                .get()
        } catch {
            XCTFail("Unexpected error", file: file, line: line)
        }
    }

    func assertJsonTable(
        source: String,
        fileContent: String,
        contains: [String:String],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let stub = SemanticAnalyzerFileServiceStub()
            stub.content = fileContent
            let jsonTable = JsonTable()
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0, jsonTable, stub).analyze() }
                .get()
            contains.forEach { key, value in
                XCTAssertNoDifference(
                    value,
                    jsonTable.get(key),
                    file: file,
                    line: line
                )
            }
        } catch {
            XCTFail("Unexpected error", file: file, line: line)
        }
    }

    func assertJsonTable(
        source: String,
        fileContent: String,
        fileExists: Bool = true,
        isAbsolutePath: Bool = false,
        errors testErrors: [SemanticAnalyzerError.ErrorType],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let stub = SemanticAnalyzerFileServiceStub()
            stub.content = fileContent
            stub.exists = fileExists
            stub.absolutePath = isAbsolutePath
            _  = try Lexer(source: source).tokenize()
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0, JsonTable(), stub).analyze() }
                .get()
        } catch let errors as [SemanticAnalyzerError] {
            let errorTypes = errors.map { $0.type }
            XCTAssertNoDifference(errorTypes, testErrors, file: file, line: line)
        } catch {
            XCTFail("Unexpected error \(error)", file: file, line: line)
        }
    }
}
