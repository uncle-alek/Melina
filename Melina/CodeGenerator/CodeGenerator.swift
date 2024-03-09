import Foundation

protocol CodeBuilder {

    func buildForProgramBeginning(_ program: Program)
    func buildForProgramEnd(_ program: Program)
    func buildForSuitBeginning(_ suite: Suite)
    func buildForSuitEnd(_ suite: Suite)
    func buildForSubscenarioBeginning(_ subscenario: Subscenario)
    func buildForSubscenarioEnd(_ subscenario: Subscenario)
    func buildForJsonDefinition(_ jsonDefinition: JsonDefinition)
    func buildForScenarioBeginning(_ scenario: Scenario)
    func buildForScenarioEnd(_ scenario: Scenario)
    func buildForArgumentsBeginning(_ arguments: [Argument])
    func buildForArgumentBeginning(_ argument: Argument)
    func buildForArgumentValue(_ value: Token)
    func buildForJsonReference(_ jsonReference: JsonReference)
    func buildForArgumentEnd(_ argument: Argument)
    func buildForArgumentsEnd(_ arguments: [Argument])
    func buildForAction(_ action: Action)
    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall)
    func fileExtension() -> String
    func code() -> String

}

final class CodeGenerator {

    private let program: Program
    private let builder: CodeBuilder

    init(
        program: Program,
        _ builder: CodeBuilder
    ) {
        self.program = program
        self.builder = builder
    }

    func generate() -> Result<File, [Error]> {
        builder.buildForProgramBeginning(program)
        program.definitions.forEach(definition)
        builder.buildForProgramEnd(program)
        let file = File(fileExtension: builder.fileExtension(), content: builder.code())
        return .success(file)
    }

    func definition(_ definition: Definition) {
        switch definition {
            case .subscenario(let v): subscenario(v)
            case .suite(let v)      : suite(v)
            case .json(let v)       : jsonDefinition(v)
        }
    }

    func subscenario(_ subscenario: Subscenario) {
        builder.buildForSubscenarioBeginning(subscenario)
        subscenario.steps.forEach(step)
        builder.buildForSubscenarioEnd(subscenario)
    }

    func suite(_ suite: Suite) {
        builder.buildForSuitBeginning(suite)
        suite.scenarios.forEach(scenario)
        builder.buildForSuitEnd((suite))
    }

    func jsonDefinition(_ jsonDefinition: JsonDefinition) {
        builder.buildForJsonDefinition(jsonDefinition)
    }

    func scenario(_ scenario: Scenario) {
        builder.buildForScenarioBeginning(scenario)
        builder.buildForArgumentsBeginning(scenario.arguments)
        scenario.arguments.forEach(argument)
        builder.buildForArgumentsEnd(scenario.arguments)
        scenario.steps.forEach(step)
        builder.buildForScenarioEnd(scenario)
    }

    func argument(_ argument: Argument) {
        builder.buildForArgumentBeginning(argument)
        switch argument.value {
        case .value(let v)        : builder.buildForArgumentValue(v)
        case .jsonReference(let v): builder.buildForJsonReference(v)
        }
        builder.buildForArgumentEnd(argument)

    }

    func step(_ step: Step) {
        switch step {
            case .action(let value)         : action(value)
            case .subscenarioCall(let value): subscenarioCall(value)
        }
    }

    func action(_ action: Action) {
        builder.buildForAction(action)
    }

    func subscenarioCall(_ subscenarioCall: SubscenarioCall) {
        builder.buildForSubscenarioCall(subscenarioCall)
    }
}
