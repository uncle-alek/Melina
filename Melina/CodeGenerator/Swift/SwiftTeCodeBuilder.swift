import Foundation

final class SwiftTeCodeBuilder: CodeBuilder {

    private var commands: [SwiftTeCode.Command] = []

    func buildForSuitBeginning(_ suite: Suite) {
        commands.append(SwiftTeCode.Command(mnemonic: .suiteBegin, operands: [suite.name.lexeme]))
    }
    
    func buildForSuitEnd(_ suite: Suite) {
        commands.append(SwiftTeCode.Command(mnemonic: .suiteEnd, operands: [suite.name.lexeme]))
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
    
    func buildForStep(_ step: Step) {
        buildElement(step)
        buildAction(step)
    }
    
    func fileName(_ suite: Suite) -> String {
        return genFileName(suite.name.lexeme)
    }
    
    func code() -> String {
        return JSONSerializer.serialize(SwiftTeCode(commands: commands))
    }
    
    func reset() {
        commands = []
    }
}

private extension SwiftTeCodeBuilder {

    func buildElement(_ step: Step) {
        commands.append(SwiftTeCode.Command(mnemonic: mapElement(step.element.type), operands: [step.element.name.lexeme]))
        commands.append(SwiftTeCode.Command(mnemonic: .exists, operands: []))
        commands.append(SwiftTeCode.Command(mnemonic: .jumpIfTrue, operands: ["2"]))
        commands.append(SwiftTeCode.Command(mnemonic: .waitForExistence, operands: ["5"]))
        commands.append(SwiftTeCode.Command(mnemonic: .assertBool, operands: ["true"]))
    }

    func buildAction(_ step: Step) {
        commands.append(SwiftTeCode.Command(mnemonic: mapAction(step.action.type), operands: []))
    }

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
