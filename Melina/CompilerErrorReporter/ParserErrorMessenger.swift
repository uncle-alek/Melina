import Foundation

struct ParserErrorMessenger: ErrorMessenger {
    
    func message(for error: ParserError) -> String {
        switch error.expected {
        case .definition:
            return "Missing definition. Include a subscenario or suite definition, typically starting with a keyword `subscenario` or `suite`."
        case .step:
            return "Action type not found. Start step with an action type like `verify`, `tap`, `edit`, etc., or call a subscenario."
        case .subscenarioDefinitionName:
            return "Subscenario name missing. Specify the name for the subscenario definition."
        case .subscenarioCallName:
            return "Subscenario name missing. Specify the name for the subscenario call."
        case .suiteName:
            return "Suite name missing. Specify the name for the suite definition."
        case .scenario:
            return "'scenario' keyword not detected. Begin the scenario definition with 'scenario'."
        case .scenarioName:
            return "Scenario name missing. Specify the name for the scenario definition."
        case .argumentKey:
            return "Argument key not provided. Specify the key for the argument."
        case .argumentTo:
            return "Missing 'to'. Use 'to' to link the argument key with its value."
        case .argumentValue:
            return "Argument value not provided. Specify the value associated with the argument key."
        case .elementType:
            return "Element type not provided. Specify the type of the element like `view`, `label`, `button`, etc."
        case .elementName:
            return "Element name not provided. Specify the name of the element."
        case .colon:
            return "Missing `:` symbol. Begin the scope with a colon."
        case .end:
            return "Missing 'end' keyword. Conclude the scope with 'end'."
        case .jsonDefinitionName:
            return "Json name missing. Specify the name for the json definition."
        case .jsonReferenceName:
            return "Json name missing. Specify the name for the json reference."
        case .jsonFile:
            return "Missing 'file'. Specify 'file' before the file path."
        case .jsonFilePath:
            return "File path not provided. Specify the path of the file."
        }
    }
}
