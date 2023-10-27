import Foundation

final class SwiftTeCodeGenerator {

    private let program: Program

    init(
        program: Program
    ) {
        self.program = program
    }

    func generate() -> Result<SwiftTeCode, [Error]> {
        let commands = program.suites.flatMap(genSuite)
        return .success(SwiftTeCode(commands: commands))
    }
}

private extension SwiftTeCodeGenerator {

    func genSuite(_ suite: Suite) -> [SwiftTeCode.Command] {
        var commands: [SwiftTeCode.Command] = []
        commands.append(SwiftTeCode.Command(mnemonic: .suiteBegin, operands: [suite.name.lexeme]))
        commands += suite.scenarios.flatMap(genScenario)
        commands.append(SwiftTeCode.Command(mnemonic: .suiteEnd, operands: [suite.name.lexeme]))
        return commands
    }

    func genScenario(_ scenario: Scenario) -> [SwiftTeCode.Command] {
        var commands: [SwiftTeCode.Command] = []
        commands.append(SwiftTeCode.Command(mnemonic: .scenarioBegin, operands: [scenario.name.lexeme]))
        commands.append(SwiftTeCode.Command(mnemonic: .application, operands: []))
        commands.append(SwiftTeCode.Command(mnemonic: .launchArgument, operands: ["RUNNING_UI_TESTS"]))
        commands += scenario.arguments.flatMap(genArgument)
        commands.append(SwiftTeCode.Command(mnemonic: .launch, operands: []))
        commands += scenario.steps.flatMap(genStep)
        commands.append(SwiftTeCode.Command(mnemonic: .terminate, operands: []))
        commands.append(SwiftTeCode.Command(mnemonic: .scenarioEnd, operands: [scenario.name.lexeme]))
        return commands
    }

    func genArgument( _ argument: Argument) -> [SwiftTeCode.Command] {
        var commands: [SwiftTeCode.Command] = []
        commands.append(SwiftTeCode.Command(mnemonic: .launchEnvironment, operands: [argument.key.lexeme, argument.value.lexeme]))
        return commands
    }

    func genStep(_ step: Step) -> [SwiftTeCode.Command] {
        var commands: [SwiftTeCode.Command] = []
        commands += getElement(step.element)
        commands += getAction(step.action)
        return commands
    }

    func getAction(_ token: Action) -> [SwiftTeCode.Command] {
        var commands: [SwiftTeCode.Command] = []
        commands.append(SwiftTeCode.Command(mnemonic: mapAction(token.type), operands: []))
        return commands
    }

    func mapAction( _ token: Token) -> SwiftTeCode.Mnemonic {
        switch token.type {
        case .tap: return .tap
        default: fatalError("Not supported action type: \(token)")
        }
    }

    func getElement(_ element: Element) -> [SwiftTeCode.Command] {
        var commands: [SwiftTeCode.Command] = []
        commands.append(SwiftTeCode.Command(mnemonic: mapElement(element.type), operands: [element.name.lexeme]))
        commands.append(SwiftTeCode.Command(mnemonic: .exists, operands: []))
        commands.append(SwiftTeCode.Command(mnemonic: .jumpIfTrue, operands: ["2"]))
        commands.append(SwiftTeCode.Command(mnemonic: .waitForExistence, operands: ["5"]))
        commands.append(SwiftTeCode.Command(mnemonic: .assertBool, operands: ["true"]))
        return commands
    }

    func mapElement( _ token: Token) -> SwiftTeCode.Mnemonic {
        switch token.type {
        case .button: return .button
        default: fatalError("Not supported element type: \(token)")
        }
    }
}
