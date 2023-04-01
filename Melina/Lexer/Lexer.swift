import Foundation

struct LexerError: Error, Equatable {
    
    let type: `Type`
    let line: Int
    
    enum `Type`: Equatable {
        case unknownSymbol
        case secondSlashRequiredForComment
        case unknowKeyword
        case newLineInStringLiteral
    }
}

final class Lexer {
    
    let keywords: [String : TokenType] = [
        "suite"       : .suite,
        "scenario"    : .scenario,
        "arguments"   : .arguments,

        "end"         : .end,
        
        "button"      : .button,
        "text"        : .text,
        "searchField" : .searchField,

        "verify"      : .verify,
        "tap"         : .tap,
        "scrollUp"    : .scrollUp,
        "scrollDown"  : .scrollDown
    ]
    
    private let source: String
    
    private var startIndex: String.Index
    private var currentIndex: String.Index
    private var line: Int
    private var tokens: [Token] = []

    init(
        source: String
    ) {
        self.source = source
        self.currentIndex = source.startIndex
        self.startIndex = source.startIndex
        self.line = 1
    }

    func tokenize() throws -> [Token] {
        
        while !isEndOfFile() {
            startIndex = currentIndex
            try scanToken()
        }
        
        return tokens + [Token(type: .eof, lexeme: "", line: line)]
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
        case _ where c.isNumber:
            try scanNumber()
        case "\"":
            try scanString()
        case _ where c.isLetter:
            try scanKeyword()
        default:
            throw LexerError(type: .unknownSymbol, line: line)
        }
    }
    
    func scanComment() throws {
        guard advance() == "/" else {
            throw LexerError(type: .secondSlashRequiredForComment, line: line)
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
            if !advance().isLetter {
                undo()
                break
            }
        }
        
        if let tokenType = keywords[lexeme()] {
            addToken(tokenType, lexeme())
        } else {
            throw LexerError(type: .unknowKeyword, line: line)
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
    
    func scanNumber() throws {
        while !isEndOfFile() {
            if !advance().isNumber {
                undo()
                break
            }
        }
        
        addToken(.number, lexeme())
    }
    
    func scanString() throws {
        while !isEndOfFile() {
            let c = advance()
            if c == "\"" {
                break
            } else if c == "\n" {
                throw LexerError(type: .newLineInStringLiteral, line: line)
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
        currentIndex == source.endIndex
    }
    
    func undo() {
        currentIndex = source.index(before: currentIndex)
    }
    
    func addToken(_ type: TokenType, _ lexeme: String = "") {
        tokens.append(.init(type: type, lexeme: lexeme, line: line))
    }
    
    func lexeme() -> String {
        String(source[startIndex..<currentIndex])
    }
    
    func stringLexeme() -> String {
        String(source[startIndex..<currentIndex].dropFirst().dropLast())
    }
}
