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
            .classDefinition(suite.name)
            .enterScope()
            .forEach(suite.scenarios) { b, e in
                b.testDefinition(e.name)
                 .enterScope()
                 .launchAppMethodCall()
                 .leaveScope()
                 .rightCurlyBrace()
            }
            .launchAppMethodDefinition()
            .leaveScope()
            .rightCurlyBrace()
            .build()
    }
}

final class SwiftCodeBuilder {
    
    private var code: String = ""
    private var scopeLevel: Int = 0
    
    @discardableResult
    func enterScope() -> Self {
        scopeLevel += 1
        return self
    }
    
    @discardableResult
    func leaveScope() -> Self {
        scopeLevel -= 1
        return self
    }
    
    @discardableResult
    func forEach<T>(_ list: [T], block: (SwiftCodeBuilder,T) -> Void) -> Self {
        list.forEach {
            block(self, $0)
        }
        return self
    }
    
    @discardableResult
    func imports() -> Self {
        code += "import XCTest" + newLine(2)
        return self
    }
    
    @discardableResult
    func classDefinition(_ name: String) -> Self {
        code += "final class \(name.className): XCTestCase {" + newLine(2)
        return self
    }
    
    @discardableResult
    func testDefinition(_ name: String) -> Self {
        code += tab() + "func \(name.methodName)() {" + newLine()
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
    
    @discardableResult
    func rightCurlyBrace() -> Self {
        code += tab() + "}" + newLine(2)
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
