import Foundation

enum SwiftCodeGeneratorError: Error, Equatable {
    case unknown
}

final class SwiftCodeGenerator {
    
    private let program: Program
    private var scopeLevel: Int = 0
    
    init(
        program: Program
    ) {
        self.program = program
    }
    
    func generate() throws -> Code {
        let testClasses = program.suites.map(testClass)
        return Code(testClasses: testClasses)
    }
}

private extension SwiftCodeGenerator {
        
    func testClass(_ suite: Suite) -> TestClass {
        TestClass(
            name: fileName(suite.name),
            sourceCode: generateTestClass(suite)
        )
    }
    
    func generateTestClass(_ suite: Suite) -> String {
        apply("") { s in
            s += tab() + imports() + newLine(2)
            s += tab() + classDefinition(suite.name) + newLine(2)
            scopeLevel += 1
            s += suite.scenarios.map(generateTestMethod).joined(separator: newLine(2))
            s += launchAppMethodDefinition() + newLine()
            scopeLevel -= 1
            s += tab() + rightCurlyBrace() + newLine()
        }
    }
    
    func generateTestMethod(_ scenario: Scenario) -> String {
        apply("") { s in
            s += tab() + testDefinition(scenario.name) + newLine()
            scopeLevel += 1
            s += tab() + callLaunchAppMethod() + newLine()
            scopeLevel -= 1
            s += tab() + rightCurlyBrace() + newLine(2)
        }
    }
}

private extension SwiftCodeGenerator {
    
    func imports() -> String {
        "import XCTest"
    }
    
    func classDefinition(_ name: String) -> String {
        "final class \(className(name)): XCTestCase {"
    }
    
    func fileName(_ name: String) -> String {
        className(name) + ".swift"
    }
    
    func className(_ name: String) -> String {
        name
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
        + "Tests"
    }
    
    func testDefinition(_ name: String) -> String {
        "func \(methodName(name)) {"
    }
    
    func methodName(_ name: String) -> String {
       "test" + name
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
        + "()"
    }
    
    func callLaunchAppMethod() -> String {
        "let app = launchApp()"
    }
    
    func launchAppMethodDefinition() -> String {
        """
            private func launchApp() {
                continueAfterFailure = false
                let app: XCUIApplication = XCUIApplication()
                app.launchArguments = []
                return app
            }
        """
    }
}

private extension SwiftCodeGenerator {
    
    func newLine(_ count: Int = 1) -> String {
        String(repeating: "\n", count: count)
    }
    
    func tab() -> String {
        String(repeating: " ", count: scopeLevel * 4)
    }
    
    func rightCurlyBrace() -> String {
        "}"
    }
}

func apply<T>(_ obj: T, block: (inout T) -> Void) -> T {
    var copy = obj
    block(&copy)
    return copy
}
