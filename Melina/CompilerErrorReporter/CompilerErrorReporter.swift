import Foundation

final class CompilerErrorReporter {
    
    private var pemb: () -> CompilerErrorMessageBuilder<ParserError, ParserErrorMessenger>
    private var lemb: () -> CompilerErrorMessageBuilder<LexerError, LexerErrorMessenger>
    private var saemb: () -> CompilerErrorMessageBuilder<SemanticAnalyzerError, SemanticAnalyzerErrorMessenger>
    private let print: (_ items: String) -> Void
    
    init(
        filePath: String,
        source: String,
        print: @escaping (_ items: String) -> Void = { Swift.print($0, terminator: "") }
    ) {
        self.print = print
        self.pemb = { CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: ParserErrorMessenger()) }
        self.lemb = { CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: LexerErrorMessenger()) }
        self.saemb = { CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: SemanticAnalyzerErrorMessenger()) }
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
            lemb().fullMessage(line: lexerError.line, error: lexerError)
                .errorLine(index: lexerError.index)
                .marker(index: lexerError.index)
                .build()
        )
    }
    
    func report(parserError: ParserError) {
        print(
            pemb().fullMessage(line: parserError.line, error: parserError)
                .errorLine(index: parserError.index)
                .marker(index: parserError.index)
                .build()
        )
    }
    
    func report(semanticAnalyzerError: SemanticAnalyzerError) {
        switch semanticAnalyzerError {
        case .incompatibleAction(let action, _):
            print(
                saemb().fullMessage(line: action.line, error: semanticAnalyzerError)
                    .errorLine(index: action.startIndex)
                    .marker(index: action.startIndex)
                    .build()
            )
        case .suiteNameCollision(let suite):
            print(
                saemb().fullMessage(line: suite.line, error: semanticAnalyzerError)
                    .errorLine(index: suite.startIndex)
                    .marker(index: suite.startIndex)
                    .build()
            )
        case .scenarioNameCollision(let scenario):
            print(
                saemb().fullMessage(line: scenario.line, error: semanticAnalyzerError)
                    .errorLine(index: scenario.startIndex)
                    .marker(index: scenario.startIndex)
                    .build()
            )
        }
    }
}
