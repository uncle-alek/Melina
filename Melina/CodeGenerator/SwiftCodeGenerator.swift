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
        let testClasses = program.suites.map(generateTestClass)
        return Code(testClasses: testClasses)
    }
}

private extension SwiftCodeGenerator {
        
    func generateTestClass(_ suite: Suite) -> String {
        var testClass = ""
        testClass += imports()
        testClass += classDefinition(suite.name)
        scopeLevel += 1
        testClass += suite.scenarios.map(generateTestMethod).joined(separator: newLine())
        testClass += generateLaunchAppMethod()
        scopeLevel -= 1
        testClass += rightCurlyBrace()
        return testClass
    }
    
    func generateTestMethod(_ scenario: Scenario) -> String {
        var testMethod = ""
        testMethod += tab() + testDefinition(scenario.name)
        scopeLevel += 1
        testMethod += tab() + launchAppMethod() + newLine()
        scopeLevel -= 1
        testMethod += tab() + rightCurlyBrace() + newLine(2)
        return testMethod
    }
    
    func generateLaunchAppMethod() -> String {
        """
            private func \(launchAppMethod()) {
                continueAfterFailure = false
                let app: XCUIApplication = XCUIApplication()
                app.launchArguments = []
            }
        """ + newLine()
    }
}

private extension SwiftCodeGenerator {
    
    func imports() -> String {
        "import XCTest" + newLine(2)
    }
    
    func classDefinition(_ name: String) -> String {
        "final class \(className(name)): XCTestCase {" + newLine(2)
    }
    
    func className(_ name: String) -> String {
        name
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
        + "Tests"
    }
    
    func testDefinition(_ name: String) -> String {
        "func \(methodName(name)) {" + newLine()
    }
    
    func methodName(_ name: String) -> String {
       "test" + name
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
        + "()"
    }
    
    func launchAppMethod() -> String {
        "launchApp()"
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
