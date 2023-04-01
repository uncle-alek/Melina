import Foundation

final class SwiftCodeGenerator: Visitor {
    
    private let program: Program
    private var generatedCode: String = ""
    private var scopeLevel: Int = 0
    private var testClasses: [TestClass] = []
    
    init(
        program: Program
    ) {
        self.program = program
    }
    
    func visit(_ program: Program) {
        program.suites.forEach { suite in
            suite.accept(self)
            testClasses.append(TestClass(suite.name.fileName, generatedCode))
            generatedCode = ""
        }
    }
    
    func visit(_ suite: Suite) {
        generatedCode += "import XCTest" + newLine(2)
        generatedCode += "final class \(suite.name.className): XCTestCase {" + newLine(2)
        scopeLevel += 1
        suite.scenarios.forEach { $0.accept(self) }
        generatedCode +=
        """
            private func launchApp() {
                continueAfterFailure = false
                let app: XCUIApplication = XCUIApplication()
                app.launchArguments = []
                return app
            }
        """ + newLine()
        scopeLevel -= 1
        generatedCode += "}" + newLine()
    }
    
    func visit(_ scenario: Scenario) {
        generatedCode += tab() + "func \(scenario.name.methodName)() {" + newLine()
        scopeLevel += 1
        generatedCode += tab() + "let app = launchApp()" + newLine()
        generatedCode += tab() + "app.launchEnvironment = [" + newLine()
        scopeLevel += 1
        scenario.arguments.forEach { $0.accept(self) }
        scopeLevel -= 1
        generatedCode += tab() + "]" + newLine()
        scenario.steps.forEach { $0.accept(self) }
        scopeLevel -= 1
        generatedCode += tab() + "}" + newLine(2)
    }
    
    func visit(_ argument: Argument) {
        generatedCode += tab() + "\"\(argument.key)\"" + " : " + "\"\(argument.value)\"" + "," + newLine()
    }
    
    func visit(_ step: Step) {

    }
    
    func generate() -> Code {
        program.accept(self)
        return Code(testClasses: testClasses)
    }
}

extension SwiftCodeGenerator {
    
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
