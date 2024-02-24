import Foundation

final class ASTPrinter {
    
    private var formattedText: String = ""
    private let program: Program
    
    init(
        program: Program
    ) {
        self.program = program
    }

    func toString() -> String {
        programToString(program)
        return formattedText
    }
}

private extension ASTPrinter {

    func programToString(_ program: Program) {
        formattedText += "<Program_beggining>" + "\n"
        program.definitions.forEach(definitionToString)
        formattedText += "<Program_end>"
    }

    func definitionToString(_ definition: Definition) {
        switch definition {
        case .suite(let value): suiteToString(value)
        case .subscenario(let value): subscenarioToString(value)
        }
    }

    func suiteToString(_ suite: Suite) {
        formattedText += "<Suite_beggining>:\(suite.name.lexeme)" + "\n"
        suite.scenarios.forEach(scenarioToString)
        formattedText += "<Suite_end>" + "\n"
    }

    func subscenarioToString(_ subscenario: Subscenario) {
        
    }

    func scenarioToString(_ scenario: Scenario) {
        formattedText += "<Scenario_begging>:\(scenario.name.lexeme)" + "\n"
        if !scenario.arguments.isEmpty {
            formattedText += "Arguments:["
            scenario.arguments.forEach(argumentToString)
            formattedText += "]" + "\n"
        }
        formattedText += "Steps:["
        scenario.steps.forEach(stepToString)
        formattedText += "]" + "\n"
        formattedText += "<Scenario_end>" + "\n"
    }

    func argumentToString(_ argument: Argument) {
        formattedText += "\(argument.key.lexeme):\(argument.value.lexeme),"
    }

    func stepToString(_ step: Step) {
        switch step {
        case .action(let value): actionToString(value)
        case .subscenarioCall(let value): subscenarioCallToString(value)
        }
    }

    func actionToString(_ action: Action) {
        formattedText += "\(action.type.lexeme)-\(action.element.type.lexeme):\(action.element.name.lexeme),"
    }

    func subscenarioCallToString(_ subscenarioCall: SubscenarioCall) {

    }
}
