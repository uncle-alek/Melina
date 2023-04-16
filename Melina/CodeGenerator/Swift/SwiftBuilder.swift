final class SwiftCodeBuilder {
    
    private var generatedCode: String = ""
    private var scopeLevel: Int = 0
    
    func buildImports() {
        generatedCode += "import XCTest" + newLine(2)
    }
    
    func buildClass(suite: Suite, block: () -> Void) {
        generatedCode += "final class \(suite.name.lexeme.className): XCTestCase {" + newLine(2)
        scopeLevel += 1
        block()
        scopeLevel -= 1
        generatedCode += "}" + newLine(2)
    }
    
    func buildTestMethod(scenario: Scenario, block: () -> Void) {
        generatedCode += tab() + "func \(scenario.name.lexeme.methodName)() {" + newLine()
        scopeLevel += 1
        block()
        scopeLevel -= 1
        generatedCode += tab() + "}" + newLine(2)
    }
    
    func buildLaunchAppCall(scenario: Scenario, block: () -> Void) {
        generatedCode += tab() + "let app = launchApp([" + newLine()
        scopeLevel += 1
        block()
        scopeLevel -= 1
        generatedCode += tab() + "])" + newLine()
    }
    
    func buildArgumentPair(argument: Argument) {
        generatedCode += tab() + "\"\(argument.key.lexeme)\"" + " : " + "\"\(argument.value.lexeme)\"" + "," + newLine()
    }
    
    func buildXCTestApiCall(step: Step) {
        generatedCode += tab() + "app." + "\(step.element.type.generatedElement!)" + "[\"\(step.element.name.lexeme)\"]." + "firstMatch." + "\(step.action.type.generatedAction!)" + newLine()
    }
    
    func buildLaunchAppMethod() {
        generatedCode +=
        """
            private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
                continueAfterFailure = false
                let app = XCUIApplication()
                app.launchEnvironment = launchEnvironment
                app.launch()
                return app
            }
        """ + newLine()
    }
    
    func buildXCUIElementExtension() {
        generatedCode += """
        private extension XCUIElement {
            func verifyExistence(timeout: TimeInterval) {
                XCTAssertTrue(self.waitForExistence(timeout: timeout))
            }
        }
        """ + newLine()
    }
    
    func result() -> String {
        generatedCode
    }
}

extension SwiftCodeBuilder {
    
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

extension Token {
    
    var generatedElement: String? {
        switch self.type {
        case .text: return "staticTexts"
        case .searchField: return "searchFields"
        case .button: return "buttons"
        default: return nil
        }
    }
    
    var generatedAction: String? {
        switch self.type {
        case .tap: return "tap()"
        case .verify: return "verifyExistence(timeout: 3)"
        case .scrollUp: return "swipeUp()"
        case .scrollDown: return "swipeDown()"
        default: return nil
        }
    }
}
