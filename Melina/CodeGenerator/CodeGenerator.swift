import Foundation

protocol CodeBuilder {

    func buildForSuitBeginning(_ suite: Suite)
    func buildForSuitEnd(_ suite: Suite)
    func buildForSubscenarioBeginning(_ subscenario: Subscenario)
    func buildForSubscenarioEnd(_ subscenario: Subscenario)
    func buildForScenarioBeginning(_ scenario: Scenario)
    func buildForScenarioEnd(_ scenario: Scenario)
    func buildForArgumentsBeginning(_ arguments: [Argument])
    func buildForArgument(_ argument: Argument)
    func buildForArgumentsEnd(_ arguments: [Argument])
    func buildForAction(_ action: Action)
    func buildForSubscenarioCall(_ subscenarioCall: SubscenarioCall)
    func fileName(_ definition: Definition) -> String
    func code() -> String
    func reset()

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

    func generate() -> Result<Code, [Error]> {
        let files = program.definitions.map {
            definition($0)
            let file = File(name: builder.fileName($0), content: builder.code())
            builder.reset()
            return file
        }
        return .success(Code(files: files))
    }

    func definition(_ definition: Definition) {
        switch definition {
            case .subscenario(let value): subscenario(value)
            case .suite(let value): suite(value)
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

    func scenario(_ scenario: Scenario) {
        builder.buildForScenarioBeginning(scenario)
        builder.buildForArgumentsBeginning(scenario.arguments)
        scenario.arguments.forEach(argument)
        builder.buildForArgumentsEnd(scenario.arguments)
        scenario.steps.forEach(step)
        builder.buildForScenarioEnd(scenario)
    }

    func argument(_ argument: Argument) {
        builder.buildForArgument(argument)
    }

    func step(_ step: Step) {
        switch step {
            case .action(let value): action(value)
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