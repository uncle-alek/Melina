import Foundation

struct Token: Equatable {
    
    let type: TokenType
    let lexeme: String
    let line: Int
}

enum TokenType: Equatable {
    case eof,
         colon
    
    case identifier,
         number,
         string
    
    case suite,
         scenario,
         end,
         open,
         tap,
         expect
}
