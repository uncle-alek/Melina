import Foundation

struct ParserErrorMessenger: ErrorMessenger {
    
    func message(for error: ParserError) -> String {
        switch error.expected {
        case .definition:      return "expected a subscenario definition or suite definition"
        case .step:            return "expected action type: verify, tap, edit..., or subscenario call"

        case .subscenarioName: return "expected subscenario name"

        case .suiteName:       return "expected name in suite definition"

        case .scenario:        return "expected keyword 'scenario' in scenario definition"
        case .scenarioName:    return "expected name in scenario definition"

        case .argumentKey:     return "expected argument key"
        case .argumentTo:      return "expected 'to' between argument key and value"
        case .argumentValue:   return "expected argument value"

        case .elementType:     return "expected element type: view, label, button..."
        case .elementName:     return "expected element name"

        case .colon:           return "expected ':' in the beggining of the scope"
        case .end:             return "expected 'end' at the end of the scope"
        }
    }
}
