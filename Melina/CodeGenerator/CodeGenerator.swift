import Foundation

protocol CodeBuilder {

    func buildForSuitBeginning(_ suite: Suite)
    func buildForSuitEnd(_ suite: Suite)
    func buildForScenarioBeginning(_ scenario: Scenario)
    func buildForScenarioEnd(_ scenario: Scenario)
    func buildForArgumentsBeginning(_ arguments: [Argument])
    func buildForArgument(_ argument: Argument)
    func buildForArgumentsEnd(_ arguments: [Argument])
    func buildForStep(_ step: Step)
    func fileName(_ suit: Suite) -> String
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
        let files = program.suites.map {
            suit($0)
            let file = File(
                name: builder.fileName($0),
                content: builder.code()
            )
            builder.reset()
            return file
        }
        return .success(Code(files: files))
    }

    func suit(_ suit: Suite) {
        builder.buildForSuitBeginning(suit)
        suit.scenarios.forEach(scenario)
        builder.buildForSuitEnd((suit))
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
        builder.buildForStep(step)
    }
}
