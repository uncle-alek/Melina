import Foundation

struct Code: Equatable {
    let testClasses: [TestClass]
}

struct TestClass: Equatable {
    let name: String
    let sourceCode: String
}
