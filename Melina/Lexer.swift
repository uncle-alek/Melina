import Foundation

enum LexerError: Error {
    case unknownSymbol
    case wrongComment
    case wrongKeyword
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
    
    let spacing: [String] = [
        " ", "\t", "\r", "\n"
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
        case "/":
            try scanComment()
        case _ where c.isNumber:
            try scanNumber()
        case "\"":
            try scanString()
        case _ where c.isLetter:
            try scanKeyword()
        default:
            break
        }
    }
    
    func scanComment() throws {
        guard advance() == "/" else {
            throw LexerError.wrongComment
        }
        while !isEndOfFile() {
            let c = advance()
            if c == "\n" {
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
            throw LexerError.wrongKeyword
        }
    }
    
    func scanNewLine() {
        addToken(.newLine)
        line += 1
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
