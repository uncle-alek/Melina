import Foundation

enum LexerError: Error, Equatable {
    case unknownSymbol
    case secondSlashRequiredForComment
    case unknowKeyword
    case newLineInStringLiteral
}

final class Lexer {
    
    let keywords: [String : TokenType] = [
        "suite" : .suite,
        "scenario" : .scenario,
        "end" : .end,
        "open" : .open,
        "tap" : .tap,
        "expect" : .expect
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
        
        return tokens + [Token(type: .eof, lexeme: "", line: 0)]
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
            throw LexerError.unknownSymbol
        }
    }
    
    func scanComment() throws {
        guard advance() == "/" else {
            throw LexerError.secondSlashRequiredForComment
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
            throw LexerError.unknowKeyword
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
                throw LexerError.newLineInStringLiteral
            }
        }
        
        addToken(.string, lexeme())
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
    
    func peek() -> Character {
        source[currentIndex]
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
}
