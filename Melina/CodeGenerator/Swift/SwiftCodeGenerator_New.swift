import Foundation

final class SwiftCodeGenerator_New {

    private let program: Program
    private var variableCounter: Int = 0
    private var scopeLevel: Int = 0
    private let indentation: Int

    init(
        program: Program,
        indentation: Int = 4
    ) {
        self.program = program
        self.indentation = indentation
    }

    func generate() -> Result<Code, [Error]> {
        let testClasses = program.suites.map(genTestClass)
        return .success(Code(testClasses: testClasses))
    }
}

private extension SwiftCodeGenerator_New {

    func genTestClass(_ suite: Suite) -> TestClass {
        let name = genClassName(suite.name.lexeme)
        let code = genCode(suite)
        return TestClass(name: name, generatedCode: code)
    }

    func genClassName(_ lexeme: String) -> String {
        return lexeme
            .split(separator: " ")
            .map { $0.capitalized }
            .joined() + "UITests"
    }

    func genCode(_ suite: Suite) -> String {
        let imports = genImports()
        let testClass = genClass(suite)
        return imports + "\n\n" + testClass
    }

    func genImports() -> String {
        return "import XCTest"
    }

    func genClass(_ suite: Suite) -> String {
        let classDefinition = genClassDefinition(suite)
        scopeLevel += 1
        let methods = suite.scenarios.map(genMethod)
        let reducedMethods = methods.reduce("") { $0 + "\n" +  $1 }
        let launchApp = genPrivateMethodLaunchApp()
        let waitForExistenceIfNeeded = genPrivateWaitForExistenceIfNeeded()
        scopeLevel -= 1
        return classDefinition + " {\n"
            + reducedMethods + "\n"
            + launchApp + "\n\n"
            + waitForExistenceIfNeeded + "\n}"
    }

    func genClassDefinition(_ suite: Suite) -> String {
        let className = genClassName(suite.name.lexeme)
        return "final class \(className): XCTestCase"
    }

    func genMethod(_ scenario: Scenario) -> String {
        resetVariableCounter()
        let definition = genMethodDefinition(scenario)
        scopeLevel += 1
        let body = genMethodBody(scenario)
        scopeLevel -= 1
        return tab() + definition + " {\n" + body + tab() + "}\n"
    }

    func genMethodDefinition(_ scenario: Scenario) -> String {
        let methodName = genMethodName(scenario.name.lexeme)
        return "func \(methodName)()"
    }

    func genMethodBody(_ scenario: Scenario) -> String {
        let callLaunchApp = genCallLaunchApp(scenario.arguments)
        let xctestApiCalls = scenario.steps.map(genCallXCTestApi)
        let reducedXCTestApiCalls = xctestApiCalls.reduce("") { $0 + $1 }
        return callLaunchApp + reducedXCTestApiCalls
    }

    func genMethodName(_ lexeme: String) -> String {
        return "test" + lexeme
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
    }

    func genPrivateMethodLaunchApp() -> String {
        return """
\(tab())private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
\(tab())    continueAfterFailure = false
\(tab())    let app = XCUIApplication()
\(tab())    app.launchEnvironment = launchEnvironment
\(tab())    app.launch()
\(tab())    return app
\(tab())}
"""
    }

    func genPrivateWaitForExistenceIfNeeded() -> String {
        return """
\(tab())private func waitForExistenceIfNeeded(_ element: XCUIElement) {
\(tab())    if !element.exists {
\(tab())        XCTAssertTrue(element.waitForExistence(timeout: 5))
\(tab())    }
\(tab())}
"""
    }

    func genCallLaunchApp(_ arguments: [Argument]) -> String {
        let argumentLines = arguments.map(genArgument)
        let arumentsCode = argumentLines.isEmpty
            ? "[:]"
            : "[" + argumentLines.reduce("") { $0 + $1 + "," } + "]"
        return wrapLine("let app = launchApp(\(arumentsCode))")
    }

    func genArgument(_ argument: Argument) -> String {
        return "\"\(argument.key.lexeme)\"" + ":" + "\"\(argument.value.lexeme)\""
    }

    func genCallXCTestApi(_ step: Step) -> String {
        let variable = genVariableName(step.element)
        let query = step.element.type.genXCUIElementQuery
        let elementName = step.element.name.lexeme
        let method = step.action.type.genXCUIElementMethod
        let call = wrapLine("let \(variable) = app.\(query)[\"\(elementName)\"].firstMatch") +
                   wrapLine("waitForExistenceIfNeeded(\(variable))") +
                   wrapLine("\(variable).\(method)()")
        return call
    }

    func genVariableName(_ element: Element) -> String {
        updateVariableCounter()
        return element.type.genElementName + "_" + "\(variableCounter)"
    }
}

extension SwiftCodeGenerator_New {

    func tab() -> String {
        return String(repeating: " ", count: scopeLevel * indentation)
    }

    func wrapLine(_ line: String) -> String {
        return tab() + line + "\n"
    }

    func resetVariableCounter() {
        variableCounter = 0
    }

    func updateVariableCounter() {
        variableCounter += 1
    }
}

extension Token {

    var genElementName: String {
        switch self.type {
        case .text: return "text"
        case .searchField: return "searchField"
        case .button: return "button"
        default: fatalError("Not supported element type: \(self)")
        }
    }


    var genXCUIElementQuery: String {
        switch self.type {
        case .text: return "staticTexts"
        case .searchField: return "searchFields"
        case .button: return "buttons"
        default: fatalError("Not supported query type: \(self)")
        }
    }

    var genXCUIElementMethod: String {
        switch self.type {
        case .tap: return "tap"
        case .verify: return "verifyExistence"
        default: fatalError("Not supported method type: \(self)")
        }
    }
}
