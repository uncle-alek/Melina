import Foundation

struct CommandsStack {
    private var stack: [[SwiftTeCode.Command]] = []

    mutating func push(_ commands: [SwiftTeCode.Command]) {
        stack.append(commands)
    }

    mutating func pop() -> [SwiftTeCode.Command] {
        return stack.popLast()!
    }

    mutating func append(_ command: SwiftTeCode.Command) {
        var last = stack.popLast()!
        last.append(command)
        stack.append(last)
    }
}

final class SwiftTeCodeBuilder: CodeBuilder {

    private var commandsStack = CommandsStack()
    private var subscenarioTable: [String: [SwiftTeCode.Command]] = [:]
    private var currentArgumentKey: String!
    private let jsonTable: JsonTable
    private let waitForTimeout = 5

    init(
        _ jsonTable: JsonTable
    ) {
        self.jsonTable = jsonTable
    }

    func buildForProgramBeginning(_ program: Program) {
        commandsStack.push([])
    }

    func buildForProgramEnd(_ program: Program) {}

    func buildForSuitBeginning(_ suite: Suite) {}
    
    func buildForSuitEnd(_ suite: Suite) {}

    func buildForSubscenarioBeginning(_ subscenario: Subscenario) {
        commandsStack.push([])
    }

    func buildForSubscenarioEnd(_ subscenario: Subscenario) {
        let commands = commandsStack.pop()
        subscenarioTable[subscenario.name.lexeme] = commands
    }

    func buildForJsonDefinition(_ jsonDefinition: JsonDefinition) {}

    func buildForScenarioBeginning(_ scenario: Scenario) {
        commandsStack.append(.command(.application))
    }
    
    func buildForScenarioEnd(_ scenario: Scenario) {
        commandsStack.append(.command(.terminate))
    }
    
    func buildForArgumentsBeginning(_ arguments: [Argument]) {
        commandsStack.append(.command(.launchEnvironment, with: ["RUNNING_UI_TESTS", "true"]))
    }

    func buildForArgumentBeginning(_ argument: Argument) {
        currentArgumentKey = argument.key.lexeme
    }

    func buildForArgumentValue(_ value: Token) {
        commandsStack.append(.command(.launchEnvironment, with: [currentArgumentKey, value.lexeme]))
    }

    func buildForJsonReference(_ jsonReference: JsonReference) {
        commandsStack.append(.command(.launchEnvironment, with: [currentArgumentKey, jsonTable.get(jsonReference.name.lexeme)!]))
    }

    func buildForArgumentEnd(_ argument: Argument) {
        currentArgumentKey = nil
    }

    func buildForArgumentsEnd(_ arguments: [Argument]) {
        commandsStack.append(.command(.launch, with: []))
    }

    func buildForAction(_ action: Action) {
        buildElement(action)
        buildWaitFor(action)
        buildAction(action)
    }

    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall) {
        commandsStack.append(.command(.subscenarioCall, with: [subscenarioCall.name.lexeme]))
    }

    func fileExtension() -> String {
        "json"
    }
    
    func code() -> String {
        let commandsWithPlaceholders = commandsStack.pop()
        let commands = replacePlaceholders(commandsWithPlaceholders)
        return JSONSerializer.serialize(SwiftTeCode(commands: commands))
    }
}

private extension SwiftTeCodeBuilder {

    func replacePlaceholders(_ commands: [SwiftTeCode.Command]) -> [SwiftTeCode.Command] {
        var finalCommands: [SwiftTeCode.Command] = []
        for command in commands {
            if command.mnemonic == .subscenarioCall {
                let subscenarioName = command.operands[0]
                let subscenarioCommands = subscenarioTable[subscenarioName]!
                finalCommands.append(contentsOf: subscenarioCommands)
            } else {
                finalCommands.append(command)
            }
        }
        return finalCommands
    }
}

private extension SwiftTeCodeBuilder {

    func buildElement(_ action: Action) {
        let mnemonic: SwiftTeCode.Mnemonic = switch action.element.type.type {
        case .label     : .staticText
        case .textField : .textField
        case .button    : .button
        case .view      : .otherElement
        default: fatalError("Unsupported query type: \(self)")
        }
        commandsStack.append(.command(mnemonic, with: [action.element.name.lexeme]))
    }

    func buildWaitFor(_ action: Action) {
        let mnemonic: SwiftTeCode.Mnemonic = switch action.condition?.type.type {
        case .isNotExist : .waitForDisappear
        default: .waitForExistence
        }
        commandsStack.append(.command(mnemonic, with: ["\(waitForTimeout)"]))
    }

    func buildAction(_ action: Action) {
        switch action.type.type {
        case .edit   : buildEdit(action)
        case .tap    : buildTap()
        case .verify : buildVerify(action)
        default: fatalError("Not supported action type: \(action.type.lexeme)")
        }
    }

    func buildEdit(_ action: Action) {
        switch action.condition?.type.type {
        case .withText:
            commandsStack.append(.command(.typeText, with: [action.condition!.parameter!.lexeme]))
        default: fatalError("Not supported condition type: \(action.condition!.type.lexeme)")
        }
    }

    func buildTap() {
        commandsStack.append(.command(.tap))
    }

    func buildVerify(_ action: Action) {
        switch action.condition?.type.type {
        case .isExist:
            commandsStack.append(.command(.exists))
            commandsStack.append(.command(.assertTrue))
        case .isNotExist:
            commandsStack.append(.command(.exists))
            commandsStack.append(.command(.assertFalse))
        case .isSelected:
            commandsStack.append(.command(.isSelected))
            commandsStack.append(.command(.assertTrue))
        case .isNotSelected:
            commandsStack.append(.command(.isSelected))
            commandsStack.append(.command(.assertFalse))
        case .containsValue:
            commandsStack.append(.command(.value))
            commandsStack.append(.command(.assertEqual, with: [action.condition!.parameter!.lexeme]))
        default: fatalError("Not supported condition type: \(action.condition!.type.lexeme)")
        }
    }
}
