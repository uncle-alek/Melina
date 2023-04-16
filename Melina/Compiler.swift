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
    
    func compile() throws -> Code {
        let result = Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap { SemanticAnalyzer(program: $0).analyze() }
            .flatMap { SwiftCodeGenerator(program: $0).generate() }
        switch result {
        case .success(let code):
            return code
        case .failure(let errors):
            CompilerErrorReporter(filePath: filePath, source: source).report(errors: errors)
            throw CompilerError.failToCompile
        }
    }
}
