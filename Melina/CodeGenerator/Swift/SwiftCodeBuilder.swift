import Foundation

final class SwiftCodeBuilder: CodeBuilder {
    private var generatedCode: String = ""
    private var variableId: Int = 0
    private var scopeLevel: Int = 0
    private let indentation: Int

    init(
        indentation: Int = 4
    ) {
        self.indentation = indentation
    }

    func buildForProgramBeginning(_ program: Program) {
        generatedCode += wrapLine2(genImports())
    }

    func buildForProgramEnd(_ program: Program) {
        generatedCode += genPrivateMethodLaunchApp().map(wrapLine).joined()
        generatedCode += genPrivateWaitForExistenceIfNeeded().map(wrapLine).joined()
    }

    func buildForSubscenarioBeginning(_ subscenario: Subscenario) {

    }

    func buildForSubscenarioEnd(_ subscenario: Subscenario) {

    }


    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall) {

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

    func fileName(_ program: Program) -> String {
        let name = switch program.definitions.first! {
            case .subscenario(let value): value.name.lexeme
            case .suite(let value): value.name.lexeme
        }
        return genClassName(name) + ".swift"
    }

    func code() -> String {
        return generatedCode
    }
}

extension SwiftCodeBuilder {

    func genPrivateMethodLaunchApp() -> [String] {
        return [
            "fileprivate extension XCTestCase {",
            "\(tab(1))func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {",
            "\(tab(2))continueAfterFailure = false",
            "\(tab(2))let app = XCUIApplication()",
            "\(tab(2))app.launchEnvironment = launchEnvironment",
            "\(tab(2))app.launch()",
            "\(tab(2))return app",
            "\(tab(1))}",
            "}"
        ]
    }

    func genPrivateWaitForExistenceIfNeeded() -> [String] {
        return [
            "fileprivate extension XCTestCase {",
            "\(tab(1))func waitForExistenceIfNeeded(_ element: XCUIElement) {",
            "\(tab(2))if !element.exists {",
            "\(tab(3))XCTAssertTrue(element.waitForExistence(timeout: 5))",
            "\(tab(2))}",
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
