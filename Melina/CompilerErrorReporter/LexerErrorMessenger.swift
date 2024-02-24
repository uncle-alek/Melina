import Foundation

struct LexerErrorMessenger: ErrorMessenger {
 
    func message(for error: LexerError) -> String {
        switch error.type {
        case .unknownSymbol: return "unknown symbol"
        case .secondSlashRequiredForComment: return "comments require `//` in the beggining"
        case .unknownKeyword: return "unknown keyword"
        case .newLineInStringLiteral: return "unterminated string literal"
        }
    }
}
