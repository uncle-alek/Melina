import Foundation

struct Token: Equatable {
    
    let type: TokenType
    let lexeme: String
    let line: Int
    let startIndex: String.Index
    let endIndex: String.Index
}

enum TokenType: Equatable {
    case eof,
         colon,
         leftSquareBrace,
         rightSquareBrace
    
    case number,
         string
    
    case suite,
         scenario,
         arguments,
         end
    
    case name
    
    case button,
         text,
         searchField
    
    case verify,
         tap,
         scrollUp,
         scrollDown
}
