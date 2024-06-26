import Foundation

final class SwiftCodeBuilder: CodeBuilder {
    private var generatedCode: String = ""
    private var variableId: Int = 0
    private var scopeLevel: Int = 0
    private let indentation: Int
    private let waitForTimeout = 10
    private let jsonTable: JsonTable

    init(
        indentation: Int = 2,
        _ jsonTable: JsonTable
    ) {
        self.indentation = indentation
        self.jsonTable = jsonTable
    }

    func buildForProgramBeginning(_ program: Program) {
        generatedCode += wrapLine2(genMessageAboutMelina())
        generatedCode += wrapLine2(genImports())
    }

    func buildForProgramEnd(_ program: Program) {
        generatedCode += genPrivateMethodLaunchApp().map(wrapLine).joined()
        generatedCode += genPrivateAddInterruptionMonitor().map(wrapLine).joined()
        generatedCode += genPrivateWaitForExistenceIfNeeded().map(wrapLine).joined()
        generatedCode += genPrivateWaitForDisappear().map(wrapLine).joined()
    }

    func buildForSubscenarioBeginning(_ subscenario: Subscenario) {
        resetVariableId()
        generatedCode += wrapLine(genFilePrivateExtension())
        scopeLevel += 1
        generatedCode += wrapLine(genMethodDefinitionForSubscenario(subscenario.name) + " {")
        scopeLevel += 1
    }

    func buildForSubscenarioEnd(_ subscenario: Subscenario) {
        scopeLevel -= 1
        generatedCode += wrapLine("}")
        scopeLevel -= 1
        generatedCode += wrapLine2("}")
    }


    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall) {
        generatedCode += wrapLine(genMethodCallForSubscenario(subscenarioCall.name))
    }

    func buildForSuitBeginning(_ suite: Suite) {
        generatedCode += wrapLine2(genClassDefinition(suite) + " {")
        scopeLevel += 1
    }

    func buildForSuitEnd(_ suite: Suite) {
        scopeLevel -= 1
        generatedCode += wrapLine2("}")
    }

    func buildForScenarioBeginning(_ scenario: Scenario) {
        resetVariableId()
        generatedCode += wrapLine(genTestMethodDefinition(scenario.name) + " {")
        scopeLevel += 1
    }

    func buildForScenarioEnd(_ scenario: Scenario) {
        scopeLevel -= 1
        generatedCode += wrapLine2("}")
    }

    func buildForJsonDefinition(_ jsonDefinition: JsonDefinition) {
        generatedCode += generateJsonVariableAssignment(jsonDefinition).map(wrapLine).joined()
    }

    func buildForArgumentsBeginning(_ arguments: [Argument]) {
        let suffix = arguments.isEmpty ? ":])" : ""
        generatedCode += wrapLine(genLaunchApp() + "([" + suffix)
        scopeLevel += 1
    }

    func buildForArgumentBeginning(_ argument: Argument) {
        generatedCode += wrapLine0(genArgumentKey(argument))
    }

    func buildForArgumentValue(_ value: Token) {
        generatedCode += genArgumentValue(value)
    }

    func buildForJsonReference(_ jsonReference: JsonReference) {
        generatedCode += genJsonVariableName(jsonReference.name)
    }

    func buildForArgumentEnd(_ argument: Argument) {
        generatedCode += "," + "\n"
    }

    func buildForArgumentsEnd(_ arguments: [Argument]) {
        scopeLevel -= 1
        generatedCode += arguments.isEmpty ? "" : wrapLine("])")
    }

    func buildForAction(_ action: Action) {
        generatedCode += genCallXCTestApi(action).map(wrapLine).joined()
    }

    func fileExtension() -> String {
        return "swift"
    }

    func code() -> String {
        return generatedCode
    }
}

extension SwiftCodeBuilder {

    func genPrivateMethodLaunchApp() -> [String] {
        return [
            genFilePrivateExtension(),
            "\(tab(1))func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {",
            "\(tab(2))continueAfterFailure = false",
            "\(tab(2))let app = XCUIApplication()",
            "\(tab(2))app.launchEnvironment = launchEnvironment",
            "\(tab(2))app.launchArguments = [\"RUNNING_UI_TESTS\"]",
            "\(tab(2))app.launch()",
            "\(tab(2))addInterruptionMonitor(app)",
            "\(tab(2))return app",
            "\(tab(1))}",
            "}"
        ]
    }

    func genPrivateAddInterruptionMonitor() -> [String] {
        return [
            genFilePrivateExtension(),
            "\(tab(1))func addInterruptionMonitor(_ app: XCUIApplication) {",
            "\(tab(2))addUIInterruptionMonitor(withDescription: \"System Alert\") { (alert) -> Bool in",
            "\(tab(3))alert.buttons.element(boundBy: 1).tap()",
            "\(tab(3))return true",
            "\(tab(2))}",
            "\(tab(1))}",
            "}"
        ]
    }

    func genPrivateWaitForExistenceIfNeeded() -> [String] {
        return [
            genFilePrivateExtension(),
            "\(tab(1))func waitForExistenceIfNeeded(_ element: XCUIElement) {",
            "\(tab(2))if !element.exists {",
            "\(tab(3))XCTAssertTrue(element.waitForExistence(timeout: \(waitForTimeout)))",
            "\(tab(2))}",
            "\(tab(1))}",
            "}"
        ]
    }

    func genPrivateWaitForDisappear() -> [String] {
        return [
            genFilePrivateExtension(),
            "\(tab(1))func waitForDisappear(_ element: XCUIElement) {",
            "\(tab(2))let doesNotExistPredicate = NSPredicate(format: \"exists == false\")",
            "\(tab(2))expectation(for: doesNotExistPredicate, evaluatedWith: element, handler: nil)",
            "\(tab(2))waitForExpectations(timeout: \(waitForTimeout)) { error in",
            "\(tab(3))if error != nil {",
            "\(tab(4))XCTFail(\"The element did not disappear\")",
            "\(tab(3))}",
            "\(tab(2))}",
            "\(tab(1))}",
            "}"
        ]
    }

    func genImports() -> String {
        return "import XCTest"
    }

    func genMessageAboutMelina() -> String {
        return "// Generated by Melina."
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

    func genFilePrivateExtension() -> String {
        return "fileprivate extension XCTestCase {"
    }

    func genTestMethodDefinition(_ name: Token) -> String {
        let methodName = genTestMethodName(name.lexeme)
        return "func \(methodName)()"
    }

    func genMethodDefinitionForSubscenario(_ name: Token) -> String {
        let methodName = genCamelCaseName(name.lexeme)
        return "func \(methodName)(_ app: XCUIApplication)"
    }

    func genMethodCallForSubscenario(_ name: Token) -> String {
        let methodName = genCamelCaseName(name.lexeme)
        return "self.\(methodName)(app)"
    }

    func genTestMethodName(_ lexeme: String) -> String {
        return "test" + lexeme
            .split(separator: " ")
            .map { $0.capitalized }
            .joined()
    }

    func genCamelCaseName(_ lexeme: String) -> String {
        let components = lexeme.split(separator: " ").map(String.init)
        return components.first!.lowercased() + components
              .dropFirst()
              .map { $0.capitalized }
              .joined()
    }

    func genLaunchApp() -> String {
        return "let app = launchApp"
    }

    func genArgumentKey(_ argument: Argument) -> String {
        return "\"\(argument.key.lexeme)\"" + ":"
    }

    func genArgumentValue(_ value: Token) -> String {
        return "\"\(value.lexeme)\""
    }

    func generateJsonVariableAssignment(_ jsonDefinition: JsonDefinition) -> [String] {
        return [
            "fileprivate let " + genJsonVariableName(jsonDefinition.name) + " = " + "\"\"\"",
           jsonTable.get(jsonDefinition.name.lexeme)!,
           "\"\"\""
        ]
    }

    func genJsonVariableName(_ name: Token) -> String {
        return genCamelCaseName(name.lexeme) + "Json"
    }

    func genCallXCTestApi(_ action: Action) -> [String] {
        let variable = genVariableName(action.element)
        return [
            genElementQuery(action, variable: variable),
            genWaitFor(action, variable: variable),
            genEffectOnElement(action, variable: variable)
        ].flatMap { $0 }
    }

    func genElementQuery(_ action: Action, variable: String) -> [String] {
        let query = switch action.element.type.type {
        case .label     : "staticTexts"
        case .textField : "textFields"
        case .button    : "buttons"
        case .view      : "otherElements"
        default: fatalError("Unsupported query type: \(self)")
        }
        return [
            "let \(variable) = app.\(query)[\"\(action.element.name.lexeme)\"].firstMatch"
        ]
    }

    func genWaitFor(_ action: Action, variable: String) -> [String] {
        if action.condition?.type.type == .notExists {
            return [
                "waitForDisappear(\(variable))"
            ]
        } else {
            return [
                "waitForExistenceIfNeeded(\(variable))"
            ]
        }
    }

    func genEffectOnElement(_ action: Action, variable: String) -> [String] {
        return switch action.type.type {
        case .verify: genVerifyEffect(action, variable: variable)
        case .edit: genEditEffect(action, variable: variable)
        case .tap: genTapEffect(action, variable: variable)
        default: fatalError("Unsupported action type \(action.type.type)")
        }
    }

    func genVerifyEffect(_ action: Action, variable: String) -> [String] {
        return switch action.condition!.type.type {
        case .exists        : []
        case .notExists     : []
        case .selected      : ["XCTAssertTrue(\(variable).isSelected)"]
        case .notSelected   : ["XCTAssertFalse(\(variable).isSelected)"]
        case .contains      : ["XCTAssertEqual(\(variable).value as? String, \"\(action.condition!.parameter!.lexeme)\")"]
        default: fatalError("Unsupported condition type \(action.type.type)")
        }
    }

    func genEditEffect(_ action: Action, variable: String) -> [String] {
        return [
            "\(variable).tap()",
            "\(variable).typeText(\"\(action.condition!.parameter!.lexeme)\")"
        ]
    }

    func genTapEffect(_ action: Action, variable: String) -> [String] {
        return [
            "\(variable).tap()"
        ]
    }

    func genVariableName(_ element: Element) -> String {
        updateVariableId()
        let elementName  = switch element.type.type {
        case .textField : "textField"
        case .label     : "label"
        case .button    : "button"
        case .view      : "view"
        default: fatalError("Unsupported element type: \(self)")
        }
        return elementName + "_" + "\(variableId)"
    }

    func tab(_ count: Int) -> String {
        return String(repeating: " ", count: indentation * count)
    }

    func wrapLine0(_ line: String) -> String {
        return tab(scopeLevel) + line
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
