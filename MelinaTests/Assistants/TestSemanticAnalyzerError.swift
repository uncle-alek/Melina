enum TestSemanticAnalyzerError: Error, Equatable {
    case incompatibleAction(action: TestToken, element: TestToken)
    case suiteNameCollision(suite: TestToken)
    case scenarioNameCollision(scenario: TestToken)
    
    func toSemanticAnalyzerError(
        source: String
    ) -> SemanticAnalyzerError {
        switch self {
        case .incompatibleAction(let action, let element):
            return .incompatibleAction(action: action.toToken(source: source), element: element.toToken(source: source))
        case .suiteNameCollision(suite: let suite):
            return .suiteNameCollision(suite: suite.toToken(source: source))
        case .scenarioNameCollision(scenario: let scenario):
            return .scenarioNameCollision(scenario: scenario.toToken(source: source))
        }
    }
}

extension SemanticAnalyzerError {
    
    func toTestSemanticAnalyzerError(
        source: String
    ) -> TestSemanticAnalyzerError {
        switch self {
        case .incompatibleAction(let action, let element):
            return .incompatibleAction(action: action.toTestToken(source: source), element: element.toTestToken(source: source))
        case .suiteNameCollision(suite: let suite):
            return .suiteNameCollision(suite: suite.toTestToken(source: source))
        case .scenarioNameCollision(scenario: let scenario):
            return .scenarioNameCollision(scenario: scenario.toTestToken(source: source))
        }
    }
}
