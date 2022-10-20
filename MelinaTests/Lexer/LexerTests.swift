import XCTest

final class LexerTests: XCTestCase {
    
    func test_empty_source() throws {
        assert(
            source: "",
            produce: []
        )
    }
    
    func test_keyword() throws {
        assert(
            source: "suite",
            produce: [
                .init(
                    type: .suite,
                    lexeme: "suite",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "scenario",
            produce: [
                .init(
                    type: .scenario,
                    lexeme: "scenario",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "end",
            produce: [
                .init(
                    type: .end,
                    lexeme: "end",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "open",
            produce: [
                .init(
                    type: .open,
                    lexeme: "open",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "tap",
            produce: [
                .init(
                    type: .tap,
                    lexeme: "tap",
                    line: 1
                )
            ]
        )
        
        assert(
            source: "expect",
            produce: [
                .init(
                    type: .expect,
                    lexeme: "expect",
                    line: 1
                )
            ]
        )
    }
    
    func test_number() throws {
        assert(
            source: "12345",
            produce: [
                .init(
                    type: .number,
                    lexeme: "12345",
                    line: 1
                )
            ]
        )
    }
    
    func test_string() throws {
        assert(
            source: "\"Hello world\"",
            produce: [
                .init(
                    type: .string,
                    lexeme: "\"Hello world\"",
                    line: 1
                )
            ]
        )
    }
    
    func test_comment() throws {
        assert(
            source: "// This is comment",
            produce: []
        )
    }
}
