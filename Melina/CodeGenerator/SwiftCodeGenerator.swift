import Foundation

enum SwiftCodeGeneratorError: Error, Equatable {
    case unknown
}

final class SwiftCodeGenerator {
    
    private let program: Program
    private let builder: SwiftCodeBuilder
    
    init(
        program: Program
    ) {
        self.program = program
        self.builder = SwiftCodeBuilder()
    }
    
    func generate() throws -> Code {
        let testClasses = program.suites.map(testClass)
        return Code(testClasses: testClasses)
    }
}

private extension SwiftCodeGenerator {
        
    func testClass(_ suite: Suite) -> TestClass {
        TestClass(
            name: suite.name.fileName,
            sourceCode: generateTestClass(suite)
        )
    }
    
    func generateTestClass(_ suite: Suite) -> String {
        builder
            .imports()
            .classDefinition(suite.name) { b in
                b.testDefinition(suite.scenarios) { b,_ in
                    b.launchAppMethodCall()
                }
                .launchAppMethodDefinition()
            }
            .build()
    }
}

final class SwiftCodeBuilder {
    
    private var code: String = ""
    private var scopeLevel: Int = 0
    
    @discardableResult
    func imports() -> Self {
        code += "import XCTest" + newLine(2)
        return self
    }
    
    @discardableResult
    func classDefinition(_ name: String, block: (Self) -> Void) -> Self {
        code += "final class \(name.className): XCTestCase {" + newLine(2)
        scopeLevel += 1
        block(self)
        scopeLevel -= 1
        code += "}" + newLine()
        return self
    }
    
    @discardableResult
    func testDefinition(_ scenarios: [Scenario], block: (Self, Scenario) -> Void) -> Self {
        scenarios.forEach {
            code += tab() + "func \($0.name.methodName)() {" + newLine()
            scopeLevel += 1
            block(self, $0)
            scopeLevel -= 1
            code += tab() + "}" + newLine(2)
        }
        return self
    }
    
    @discardableResult
    func launchAppMethodCall() -> Self {
        code += tab() + "let app = launchApp()" + newLine()
        return self
    }
    
    @discardableResult
    func launchAppMethodDefinition() -> Self {
        code +=
        """
            private func launchApp() {
                continueAfterFailure = false
                let app: XCUIApplication = XCUIApplication()
                app.launchArguments = []
                return app
            }
        """ + newLine()
        return self
    }
    
    func build() -> String {
        code
    }
}

private extension SwiftCodeBuilder {
    
    func newLine(_ count: Int = 1) -> String {
        String(repeating: "\n", count: count)
    }
    
    func tab() -> String {
        String(repeating: " ", count: scopeLevel * 4)
    }
}

extension String {
    
    var fileName: String {
        className + ".swift"
    }
    
    var className: String {
        self
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
        + "Tests"
    }
    
    var methodName: String {
        "test" + self
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
    }
}
