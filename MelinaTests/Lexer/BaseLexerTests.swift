import CustomDump
import XCTest

open class BaseLexerTests: XCTestCase {
   
    func assert(
        source: String,
        produce testTokens: [TestToken],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let result = try Lexer(source: source).tokenize()
            let resultTestTokens = result.map { $0.toTestToken(source: source) }
            XCTAssertNoDifference(resultTestTokens.last?.type, .eof, file: file, line: line)
            XCTAssertNoDifference(resultTestTokens.dropLast(), testTokens, file: file, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
    
    func assert(
        source: String,
        throws error: LexerError,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try Lexer(source: source).tokenize(), file: file, line: line) { e in
            XCTAssertNoDifference(e as! LexerError, error, file: file, line: line)
        }
    }
}


struct TestToken: Equatable {
    
    let type: TokenType
    let lexeme: String
    let line: Int
    let startOffset: Int
    let endOffset: Int
    
    init(
        type: TokenType,
        lexeme: String,
        line: Int = 1,
        startOffset: Int = 0,
        endOffset: Int? = nil
    ) {
        self.type = type
        self.lexeme = lexeme
        self.line = line
        self.startOffset = startOffset
        self.endOffset = endOffset ?? lexeme.count
    }
}

extension Token {
    
    func toTestToken(
        source: String
    ) -> TestToken {
        TestToken(
            type: type,
            lexeme: lexeme,
            line: line,
            startOffset: source.distance(from: source.startIndex, to: startIndex),
            endOffset: source.distance(from: source.startIndex, to: endIndex)
        )
    }
}
