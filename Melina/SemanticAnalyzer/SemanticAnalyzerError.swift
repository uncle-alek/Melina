struct SemanticAnalyzerError: Error, Equatable {
    enum ErrorType: Equatable {
        case incompatibleElement
        case incompatibleCondition
        case missingCondition
        case suiteNameCollision
        case scenarioNameCollision
        case subscenarioRecursion
        case subscenarioNameCollision
        case subscenarioDefinitionNotFound
    }

    let type: ErrorType
    let suite: Token?
    let scenario: Token?
    let action: Token?
    let element: Token?
    let condition: Token?
    let subscenarioDefinition: Token?
    let subscenarioCall: Token?

    init(
        type: ErrorType,
        suite: Token? = nil,
        scenario: Token? = nil,
        action: Token? = nil,
        element: Token? = nil,
        condition: Token? = nil,
        subscenarioDefinition: Token? = nil,
        subscenarioCall: Token? = nil
    ) {
        self.type = type
        self.suite = suite
        self.scenario = scenario
        self.action = action
        self.element = element
        self.condition = condition
        self.subscenarioDefinition = subscenarioDefinition
        self.subscenarioCall = subscenarioCall
    }

    static func incompatibleElement(action: Token, element: Token) -> Self {
        return SemanticAnalyzerError(type: .incompatibleElement, action: action, element: element)
    }

    static func incompatibleCondition(action: Token, condition: Token) -> Self {
        return SemanticAnalyzerError(type: .incompatibleCondition, action: action, condition: condition)
    }

    static func missingCondition(action: Token) -> Self {
        return SemanticAnalyzerError(type: .missingCondition, action: action)
    }

    static func suiteNameCollision(suite: Token) -> Self {
        return SemanticAnalyzerError(type: .suiteNameCollision, suite: suite)
    }

    static func scenarioNameCollision(scenario: Token) -> Self {
        return SemanticAnalyzerError(type: .scenarioNameCollision, scenario: scenario)
    }

    static func subscenarioRecursion(definition: Token, call: Token) -> Self {
        return SemanticAnalyzerError(type: .subscenarioRecursion, subscenarioDefinition: definition, subscenarioCall: call)
    }

    static func subscenarioNameCollision(definition: Token) -> Self {
        return SemanticAnalyzerError(type: .subscenarioNameCollision, subscenarioDefinition: definition)
    }

    static func subscenarioDefinitionNotFound(call: Token) -> Self {
        return SemanticAnalyzerError(type: .subscenarioDefinitionNotFound, subscenarioCall: call)
    }
}
