import Foundation

final class ErrorReporter {
    
    private let pemb: ErrorMessageBuilder<ParserError, ParserErrorMessenger>
    private let lemb: ErrorMessageBuilder<LexerError, LexerErrorMessenger>
    private let fsemb: ErrorMessageBuilder<FileServiceError, FileServiceErrorMessenger>
    private let saemb: ErrorMessageBuilder<SemanticAnalyzerError, SemanticAnalyzerErrorMessenger>
    private let print: (_ items: String) -> Void
    
    init(
        filePath: String,
        source: String,
        print: @escaping (_ items: String) -> Void
    ) {
        self.pemb = ErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: ParserErrorMessenger())
        self.lemb = ErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: LexerErrorMessenger())
        self.fsemb = ErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: FileServiceErrorMessenger())
        self.saemb = ErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: SemanticAnalyzerErrorMessenger())
        self.print = print
    }
    
    func report(error: Error) {
        switch error {
        case is LexerError: report(lexerError: error as! LexerError)
        case is ParserError: report(parserError: error as! ParserError)
        case is FileServiceError: report(fileServiceError: error as! FileServiceError)
        case is SemanticAnalyzerError: report(semanticAnalyzerError: error as! SemanticAnalyzerError)
        default: fatalError("Unknown error")
        }
    }
}

private extension ErrorReporter {
    
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
    
    func report(fileServiceError: FileServiceError) {
        print(
            fsemb.simpleMessage(error: fileServiceError)
                .build()
        )
    }
    
    func report(semanticAnalyzerError: SemanticAnalyzerError) {
        print(
            saemb.fullMessage(line: 0, error: semanticAnalyzerError)
                .build()
        )
    }
}
