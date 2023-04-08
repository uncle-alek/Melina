import Foundation

struct LexerErrorMessenger: ErrorMessenger {
 
    func message(for error: LexerError) -> String {
        switch error.type {
        case .unknownSymbol: return "unknown symbol"
        case .secondSlashRequiredForComment: return "comments require `//` in the beggining"
        case .unknowKeyword: return "unknown keyword"
        case .newLineInStringLiteral: return "unterminated string literal"
        }
    }
}
