import Foundation

final class ErrorReporter {
    
    private let pemb: ErrorMessageBuilder<ParserError, ParserErrorMessenger>
    private let lemb: ErrorMessageBuilder<LexerError, LexerErrorMessenger>
    
    init(
        filePath: String,
        source: String
    ) {
        self.pemb = ErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: ParserErrorMessenger())
        self.lemb = ErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: LexerErrorMessenger())
    }
    
    func report(error: Error) {
        switch error {
        case is LexerError: report(lexerError: error as! LexerError)
        case is ParserError: report(parserError: error as! ParserError)
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
}
