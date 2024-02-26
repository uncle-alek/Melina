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
         arguments

    case button,
         textField,
         label,
         view

    case verify,
         tap,
         edit

    case isSelected,
         isNotSelected,
         isExist,
         isNotExist,
         containsValue,
         withText

    case subscenario
}
