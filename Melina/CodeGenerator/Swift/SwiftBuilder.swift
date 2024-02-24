import Foundation

final class SwiftBuilder: CodeBuilder {
    func buildForSubscenarioBeginning(_ subscenario: Subscenario) {

    }
    
    func buildForSubscenarioEnd(_ subscenario: Subscenario) {

    }

    
    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall) {

    }
    
    func fileName(_ definition: Definition) -> String {
        ""
    }
    

    private var generatedCode: String = ""
    private var variableId: Int = 0
    private var scopeLevel: Int = 0
    private let indentation: Int

    init(
        indentation: Int = 4
    ) {
        self.indentation = indentation
    }

    func buildForSuitBeginning(_ suite: Suite) {
        generatedCode += wrapLine2(genImports())
        generatedCode += wrapLine2(genClassDefinition(suite) + " {")
        scopeLevel += 1
    }

    func buildForSuitEnd(_ suite: Suite) {
        generatedCode += genPrivateMethodLaunchApp().map(wrapLine).joined()
        generatedCode += genPrivateWaitForExistenceIfNeeded().map(wrapLine).joined()
        scopeLevel -= 1
        generatedCode += wrapLine("}")
    }

    func buildForScenarioBeginning(_ scenario: Scenario) {
        resetVariableId()
        generatedCode += wrapLine(genMethodDefinition(scenario) + " {")
        scopeLevel += 1
    }

    func buildForScenarioEnd(_ scenario: Scenario) {
        scopeLevel -= 1
        generatedCode += wrapLine2("}")
    }

    func buildForArgumentsBeginning(_ arguments: [Argument]) {
        let suffix = arguments.isEmpty ? ":])" : ""
        generatedCode += wrapLine(genLaunchApp() + "([" + suffix)
        scopeLevel += 1
    }

    func buildForArgument(_ argument: Argument) {
        generatedCode += wrapLine(genArgument(argument) + ",")
    }

    func buildForArgumentsEnd(_ arguments: [Argument]) {
        scopeLevel -= 1
        generatedCode += arguments.isEmpty ? "" : wrapLine("])")
    }

    func buildForAction(_ action: Action) {
        generatedCode += genCallXCTestApi(action).map(wrapLine).joined()
    }

    func fileName(_ suite: Suite) -> String {
        return genClassName(suite.name.lexeme) + ".swift"
    }

    func code() -> String {
        return generatedCode
    }

    func reset() {
        generatedCode = ""
        variableId = 0
        scopeLevel = 0
    }
}

extension SwiftBuilder {

    func genPrivateMethodLaunchApp() -> [String] {
        return [
            "private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {",
            "\(tab(1))continueAfterFailure = false",
            "\(tab(1))let app = XCUIApplication()",
            "\(tab(1))app.launchEnvironment = launchEnvironment",
            "\(tab(1))app.launch()",
            "\(tab(1))return app",
            "}"
        ]
    }

    func genPrivateWaitForExistenceIfNeeded() -> [String] {
        return [
            "private func waitForExistenceIfNeeded(_ element: XCUIElement) {",
            "\(tab(1))if !element.exists {",
            "\(tab(2))XCTAssertTrue(element.waitForExistence(timeout: 5))",
            "\(tab(1))}",
            "}"
        ]
    }

    func genImports() -> String {
        return "import XCTest"
    }

    func genClassDefinition(_ suite: Suite) -> String {
        let className = genClassName(suite.name.lexeme)
        return "final class \(className): XCTestCase"
    }

    func genClassName(_ lexeme: String) -> String {
        return lexeme
            .split(separator: " ")
            .map { $0.capitalized }
            .joined() + "UITests"
    }

    func genMethodDefinition(_ scenario: Scenario) -> String {
        let methodName = genMethodName(scenario.name.lexeme)
        return "func \(methodName)()"
    }

    func genMethodName(_ lexeme: String) -> String {
        return "test" + lexeme
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
    }

    func genLaunchApp() -> String {
        return "let app = launchApp"
    }

    func genArgument(_ argument: Argument) -> String {
        return "\"\(argument.key.lexeme)\"" + ":" + "\"\(argument.value.lexeme)\""
    }

    func genCallXCTestApi(_ action: Action) -> [String] {
        let variable = genVariableName(action.element)
        let query = action.element.type.genXCUIElementQuery
        let elementName = action.element.name.lexeme
        let method = action.type.genXCUIElementMethod
        return [
            "let \(variable) = app.\(query)[\"\(elementName)\"].firstMatch",
            "waitForExistenceIfNeeded(\(variable))",
            "\(variable).\(method)()"
        ]
    }

    func genVariableName(_ element: Element) -> String {
        updateVariableId()
        return element.type.genElementName + "_" + "\(variableId)"
    }

    func tab(_ count: Int) -> String {
        return String(repeating: " ", count: indentation * count)
    }

    func wrapLine(_ line: String) -> String {
        return tab(scopeLevel) + line + "\n"
    }

    func wrapLine2(_ line: String) -> String {
        return tab(scopeLevel) + line + "\n\n"
    }

    func resetVariableId() {
        variableId = 0
    }

    func updateVariableId() {
        variableId += 1
    }
}

extension Token {

    var genElementName: String {
        switch self.type {
        case .textField: return "textField"
        case .label: return "label"
        case .button: return "button"
        default: fatalError("Not supported element type: \(self)")
        }
    }


    var genXCUIElementQuery: String {
        switch self.type {
        case .label: return "staticTexts"
        case .textField: return "searchFields"
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
