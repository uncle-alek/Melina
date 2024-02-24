import Foundation

struct LexerError: Error, Equatable {
    
    let type: `Type`
    let line: Int
    let index: String.Index
    
    enum `Type`: Equatable {
        case unknownSymbol
        case secondSlashRequiredForComment
        case unknownKeyword
        case newLineInStringLiteral
    }
}

final class Lexer {
    
    let keywords: [String : TokenType] = [
        "suite"           : .suite,
        "scenario"        : .scenario,
        "subscenario"     : .subscenario,
        "arguments"       : .arguments,

        "to"              : .to,
        "end"             : .end,

        "button"          : .button,
        "textfield"       : .textField,
        "label"           : .label,
        "view"            : .view,

        "verify"          : .verify,
        "tap"             : .tap,
        "edit"            : .edit,

        "is selected"     : .isSelected,
        "is not selected" : .isNotSelected,
        "is exist"        : .isExist,
        "is not exist"    : .isNotExist,
        "contains value"  : .containsValue,
        "with text"       : .withText
    ]
    
    private let source: String
    
    private var startIndex: String.Index
    private var currentIndex: String.Index
    private var line: Int
    private var tokens: [Token] = []
    private var errors: [Error] = []

    init(
        source: String
    ) {
        self.source = source
        self.currentIndex = source.startIndex
        self.startIndex = source.startIndex
        self.line = 1
    }

    func tokenize() -> Result<[Token], [Error]> {
        while !isEndOfFile() {
            startIndex = currentIndex
            do {
                try scanToken()
            } catch {
                errors.append(error)
                break
            }
        }
        if errors.isEmpty {
            addToken(.eof)
            return .success(tokens)
        } else {
            return .failure(errors)
        }
    }
}

private extension Lexer {
    
    func scanToken() throws {
        let c = advance()
        switch c {
        case " ", "\t", "\r":
            break
        case "\n":
            scanNewLine()
        case ":":
            scanColon()
        case "/":
            try scanComment()
        case "\"":
            try scanString()
        case _ where c.isLetter:
            try scanKeyword()
        default:
            throw error(.unknownSymbol)
        }
    }
    
    func scanComment() throws {
        guard advance() == "/" else {
            throw error(.secondSlashRequiredForComment)
        }
        while !isEndOfFile() {
            if advance() == "\n" {
                undo()
                break
            }
        }
    }
    
    func scanKeyword() throws {
        while !isEndOfFile() {
            let currentChar = advance()
            if !currentChar.isLetter {
                if keywords[lexemeWithSingleSpaces()] != nil {
                    undo()
                    break
                } else if currentChar == " " {
                    continue
                }
            }
        }
        if let tokenType = keywords[lexemeWithSingleSpaces()] {
            addToken(tokenType, lexeme())
        } else {
            throw error(.unknownKeyword)
        }
    }

    func scanNewLine() {
        line += 1

        while !isEndOfFile() {
            if advance() == "\n" {
                line += 1
            } else {
                undo()
                break
            }
        }
    }
    
    func scanColon() {
        addToken(.colon)
    }
    
    func scanString() throws {
        while !isEndOfFile() {
            let c = advance()
            if c == "\"" {
                break
            } else if c == "\n" {
                throw error(.newLineInStringLiteral)
            }
        }
        
        addToken(.string, stringLexeme())
    }
}

private extension Lexer {
    
    func advance() -> Character {
        let currentChar = source[currentIndex]
        currentIndex = source.index(after: currentIndex)
        return currentChar
    }
    
    func isEndOfFile() -> Bool {
        return currentIndex == source.endIndex
    }
    
    func undo() {
        currentIndex = source.index(before: currentIndex)
    }
    
    func addToken(_ type: TokenType, _ lexeme: String = "") {
        tokens.append(.init(type: type, lexeme: lexeme, line: line, startIndex: startIndex, endIndex: currentIndex))
    }
    
    func lexeme() -> String {
        return String(source[startIndex..<currentIndex])
    }

    func lexemeWithSingleSpaces() -> String {
        return lexeme()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    func stringLexeme() -> String {
        return String(source[startIndex..<currentIndex].dropFirst().dropLast())
    }
    
    func error(_ type: LexerError.`Type`) -> LexerError {
        return LexerError(type: type, line: line, index: source.index(before: currentIndex))
    }
}
