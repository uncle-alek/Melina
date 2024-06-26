import Foundation

struct Token: Equatable, Hashable {
    
    let type: TokenType
    let lexeme: String
    let line: Int
    let startIndex: String.Index
    let endIndex: String.Index
}

enum TokenType: Equatable {
    case eof,
         colon,
         to,
         end

    case string

    case suite,
         scenario,
         arguments,
         subscenario,
         json

    case file

    case button,
         textField,
         label,
         view

    case verify,
         tap,
         edit

    case selected,
         notSelected,
         exists,
         notExists,
         contains,
         with
}
