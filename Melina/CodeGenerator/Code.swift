import Foundation

struct Code: Equatable {
    let testClasses: [TestClass]
}

struct TestClass: Equatable {
    let name: String
    let generatedCode: String
    
    init(
        _ name: String,
        _ generatedCode: String
    ) {
        self.name = name
        self.generatedCode = generatedCode
    }
}
