import Foundation

struct Token: Equatable {
    
    let type: TokenType
    let lexeme: String
    let line: Int
}

enum TokenType: Equatable {
    case eof,
         colon
    
    case number,
         string
    
    case suite,
         scenario,
         arguments,
         end
    
    case button,
         text,
         searchField
    
    case verify,
         tap,
         scrollUp,
         scrollDown
}
