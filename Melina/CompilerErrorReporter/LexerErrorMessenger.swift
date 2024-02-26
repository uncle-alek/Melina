import Foundation

struct LexerErrorMessenger: ErrorMessenger {
 
    func message(for error: LexerError) -> String {
        switch error.type {
        case .unknownSymbol:                 return "Unknown symbol."
        case .secondSlashRequiredForComment: return "Comments require `//` in the beggining."
        case .unknownKeyword:                return "Unknown keyword."
        case .newLineInStringLiteral:        return "Unterminated string literal."
        }
    }
}
