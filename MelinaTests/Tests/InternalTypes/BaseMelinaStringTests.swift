import CustomDump
import XCTest

open class BaseMelinaStringTests: XCTestCase {
    
    func assert(
        source: String,
        startIndex: Int,
        endIndex: Int,
        textLine: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let melinaString = MelinaString.create(with: source)
        let result = melinaString.textLine(source.index(by: startIndex), source.index(by: endIndex))
        XCTAssertNoDifference(result, textLine, file: file, line: line)
    }
    
    func assert(
        source: String,
        index: Int,
        offset: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let melinaString = MelinaString.create(with: source)
        let result = melinaString.offset(source.index(by: index))
        XCTAssertNoDifference(result, offset, file: file, line: line)
    }
}
