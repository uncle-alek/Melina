import XCTest

final class MelinaStringTests: BaseMelinaStringTests {
    
    func test_text_line() {
        assert(
            source: "",
            startIndex: 0,
            endIndex: 0,
            textLine: ""
        )
        
        assert(
            source: "Hello world",
            startIndex: 0,
            endIndex: 0,
            textLine: "Hello world"
        )
        
        assert(
            source: "Hello world",
            startIndex: 1,
            endIndex: 7,
            textLine: "Hello world"
        )
        
        assert(
            source: "Hello\nworld",
            startIndex: 1,
            endIndex: 7,
            textLine: "Hello\nworld"
        )
        
        assert(
            source: "Hello\nworld",
            startIndex: 1,
            endIndex: 5,
            textLine: "Hello"
        )
        
        assert(
            source: "\nHello\nworld\n",
            startIndex: 1,
            endIndex: 7,
            textLine: "Hello\nworld"
        )
    }
    
    func test_offset() {
        assert(
            source: "",
            index: 0,
            offset: 0
        )
        
        assert(
            source: "Hello world",
            index: 4,
            offset: 4
        )
        
        assert(
            source: "Hello\nworld",
            index: 10,
            offset: 4
        )
        
        assert(
            source: "\nHello\nworld\n",
            index: 10,
            offset: 3
        )
    }
}

