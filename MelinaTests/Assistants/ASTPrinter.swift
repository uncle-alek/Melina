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
        case .suite(let value): suiteDefinitionToString(value)
        case .subscenario(let value): subscenarioDefinitionToString(value)
        case .json(let value): jsonDefinitionToString(value)
        }
    }

    func suiteDefinitionToString(_ suite: Suite) {
        formattedText += "<Suite_beggining>:\(suite.name.lexeme)" + "\n"
        suite.scenarios.forEach(scenarioToString)
        formattedText += "<Suite_end>" + "\n"
    }

    func subscenarioDefinitionToString(_ subscenario: Subscenario) {
        formattedText += "<Subscenario_beggining>:\(subscenario.name.lexeme)" + "\n"
        stepsToString(subscenario.steps)
        formattedText += "<Subscenario_end>" + "\n"
    }

    func jsonDefinitionToString(_ json: JsonDefinition) {
        formattedText += "<Json_beggining>:\(json.name.lexeme)" + "\n"
        formattedText += "file:\(json.filePath.lexeme)" + "\n"
        formattedText += "<Json_end>" + "\n"
    }

    func scenarioToString(_ scenario: Scenario) {
        formattedText += "<Scenario_begging>:\(scenario.name.lexeme)" + "\n"
        if !scenario.arguments.isEmpty {
            argumentsToString(scenario.arguments)
        }
        stepsToString(scenario.steps)
        formattedText += "<Scenario_end>" + "\n"
    }

    func argumentsToString(_ arguments: [Argument]) {
        formattedText += "Arguments:[" + "\n"
        arguments.forEach(argumentToString)
        formattedText += "]" + "\n"
    }

    func argumentToString(_ argument: Argument) {
        formattedText += "\(argument.key.lexeme):"
        argumentValueToString(argument.value)
    }

    func argumentValueToString(_ argumentValue: ArgumentValue) {
        switch argumentValue {
        case .value(let v):
            formattedText += v.lexeme
        case .jsonReference(let v):
            formattedText += "json_reference:" + v.name.lexeme
        }
        formattedText += "," + "\n"
    }

    func stepsToString(_ steps: [Step]) {
        formattedText += "Steps:[" + "\n"
        steps.forEach(stepToString)
        formattedText += "]" + "\n"
    }

    func stepToString(_ step: Step) {
        switch step {
        case .action(let value): actionToString(value)
        case .subscenarioCall(let value): subscenarioCallToString(value)
        }
    }

    func actionToString(_ action: Action) {
        let actionType = action.type.lexeme
        let elementType = action.element.type.lexeme
        let elementName = action.element.name.lexeme
        let conditionType = action.condition?.type.lexeme
        let conditionParameter = action.condition?.parameter?.lexeme
        var suffix = conditionType != nil
            ? "=>" + conditionType!
            : ""
        suffix += conditionParameter != nil
            ? ":" + conditionParameter!
            : ""
        formattedText += actionType 
            + "-" + elementType
            + ":" + elementName
            + suffix + "," + "\n"
    }

    func subscenarioCallToString(_ subscenarioCall: SubscenarioCall) {
        formattedText += "subscenario:\(subscenarioCall.name.lexeme)" + "," + "\n"
    }
}
