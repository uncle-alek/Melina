import Foundation

final class ErrorReporter {
    
    private let pemb: ParserErrorMessageBuilder
    
    init(
        filePath: String,
        source: String
    ) {
        self.pemb = ParserErrorMessageBuilder(filePath: filePath, source: source)
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

    }
    
    func report(parserError: ParserError) {
        print(
            pemb.setError(parserError)
                .fullMessage()
                .errorLine()
                .marker()
                .build()
        )
    }
}
