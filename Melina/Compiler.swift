import Foundation

enum CompilerError: Error, LocalizedError {
    case failToCompile
    
    var errorDescription: String? {
        "error occurred during compilation"
    }
}

final class Compiler {
    
    private let source: String
    private let filePath: String
    
    init(
        source: String,
        filePath: String
    ) {
        self.source = source
        self.filePath = filePath
    }

    func compileSwiftCode() throws -> File {
        try compileCodeWithBuilder(SwiftCodeBuilder())
    }

    func compileSwiftTeCode() throws -> File {
        try compileCodeWithBuilder(SwiftTeCodeBuilder())
    }
}

private extension Compiler {

    func compileCodeWithBuilder(_ codeBuilder: CodeBuilder) throws -> File {
        let result = Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap { SemanticAnalyzer(program: $0).analyze() }
            .flatMap { CodeGenerator(program: $0, codeBuilder).generate() }
        switch result {
        case .success(let file):
            return file
        case .failure(let errors):
            CompilerErrorReporter(filePath: filePath, source: source).report(errors: errors)
            throw CompilerError.failToCompile
        }
    }
}
