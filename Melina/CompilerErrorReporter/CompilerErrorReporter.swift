import Foundation

final class CompilerErrorReporter {
    
    private let pemb: CompilerErrorMessageBuilder<ParserError, ParserErrorMessenger>
    private let lemb: CompilerErrorMessageBuilder<LexerError, LexerErrorMessenger>
    private let saemb: CompilerErrorMessageBuilder<SemanticAnalyzerError, SemanticAnalyzerErrorMessenger>
    private let print: (_ items: String) -> Void
    
    init(
        filePath: String,
        source: String,
        print: @escaping (_ items: String) -> Void = { Swift.print($0, terminator: "") }
    ) {
        self.pemb = CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: ParserErrorMessenger())
        self.lemb = CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: LexerErrorMessenger())
        self.saemb = CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: SemanticAnalyzerErrorMessenger())
        self.print = print
    }
    
    func report(errors: [Error]) {
        errors.forEach(report(error:))
    }
}

private extension CompilerErrorReporter {
    
    func report(error: Error) {
        switch error {
        case is LexerError: report(lexerError: error as! LexerError)
        case is ParserError: report(parserError: error as! ParserError)
        case is SemanticAnalyzerError: report(semanticAnalyzerError: error as! SemanticAnalyzerError)
        default: fatalError("Unknown error")
        }
    }
    
    func report(lexerError: LexerError) {
        print(
            lemb.fullMessage(line: lexerError.line, error: lexerError)
                .errorLine(index: lexerError.index)
                .marker(index: lexerError.index)
                .build()
        )
    }
    
    func report(parserError: ParserError) {
        print(
            pemb.fullMessage(line: parserError.line, error: parserError)
                .errorLine(index: parserError.index)
                .marker(index: parserError.index)
                .build()
        )
    }
    
    func report(semanticAnalyzerError: SemanticAnalyzerError) {
        switch semanticAnalyzerError {
        case .incompatibleAction(_, let action):
            print(
                saemb.fullMessage(line: action.line, error: semanticAnalyzerError)
                    .errorLine(index: action.startIndex)
                    .marker(index: action.startIndex)
                    .build()
            )
        }
    }
}
