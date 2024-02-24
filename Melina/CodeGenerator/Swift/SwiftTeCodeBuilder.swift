import Foundation

final class SwiftTeCodeBuilder: CodeBuilder {

    private var commands: [SwiftTeCode.Command] = []

    func buildForSuitBeginning(_ suite: Suite) {
        commands.append(SwiftTeCode.Command(mnemonic: .suiteBegin, operands: [suite.name.lexeme]))
    }
    
    func buildForSuitEnd(_ suite: Suite) {
        commands.append(SwiftTeCode.Command(mnemonic: .suiteEnd, operands: [suite.name.lexeme]))
    }

    func buildForSubscenarioBeginning(_ subscenario: Subscenario) {
    }

    func buildForSubscenarioEnd(_ subscenario: Subscenario) {
    }

    func buildForScenarioBeginning(_ scenario: Scenario) {
        commands.append(SwiftTeCode.Command(mnemonic: .scenarioBegin, operands: [scenario.name.lexeme]))
        commands.append(SwiftTeCode.Command(mnemonic: .application, operands: []))
    }
    
    func buildForScenarioEnd(_ scenario: Scenario) {
        commands.append(SwiftTeCode.Command(mnemonic: .terminate, operands: []))
        commands.append(SwiftTeCode.Command(mnemonic: .scenarioEnd, operands: [scenario.name.lexeme]))
    }
    
    func buildForArgumentsBeginning(_ arguments: [Argument]) {
        commands.append(SwiftTeCode.Command(mnemonic: .launchArgument, operands: ["RUNNING_UI_TESTS"]))
    }
    
    func buildForArgument(_ argument: Argument) {
        commands.append(SwiftTeCode.Command(mnemonic: .launchEnvironment, operands: [argument.key.lexeme, argument.value.lexeme]))
    }
    
    func buildForArgumentsEnd(_ arguments: [Argument]) {
        commands.append(SwiftTeCode.Command(mnemonic: .launch, operands: []))
    }

    func buildForAction(_ action: Action) {
        buildElement(action.element)
        buildAction(action.type)
        if let condition = action.condition {
            buildCondition(condition)
        }
    }

    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall) {}

    func fileName(_ definition: Definition) -> String {
        ""
    }
    
    func code() -> String {
        return JSONSerializer.serialize(SwiftTeCode(commands: commands))
    }
    
    func reset() {
        commands = []
    }
}

private extension SwiftTeCodeBuilder {

    func buildElement(_ element: Element) {
        commands.append(SwiftTeCode.Command(mnemonic: mapElement(element.type), operands: [element.name.lexeme]))
        commands.append(SwiftTeCode.Command(mnemonic: .exists, operands: []))
        commands.append(SwiftTeCode.Command(mnemonic: .jumpIfTrue, operands: ["2"]))
        commands.append(SwiftTeCode.Command(mnemonic: .waitForExistence, operands: ["5"]))
        commands.append(SwiftTeCode.Command(mnemonic: .assertBool, operands: ["true"]))
    }

    func buildAction(_ actionType: Token) {
        commands.append(SwiftTeCode.Command(mnemonic: mapAction(actionType), operands: []))
    }

    func buildCondition(_ condition: Condition) {}

    func genFileName(_ lexeme: String) -> String {
        return lexeme
            .split(separator: " ")
            .map { $0.capitalized }
            .joined() + "TeCode" + ".json"
    }

    func mapAction( _ token: Token) -> SwiftTeCode.Mnemonic {
        switch token.type {
        case .tap: return .tap
        default: fatalError("Not supported action type: \(token)")
        }
    }

    func mapElement( _ token: Token) -> SwiftTeCode.Mnemonic {
        switch token.type {
        case .button: return .button
        default: fatalError("Not supported element type: \(token)")
        }
    }
}
