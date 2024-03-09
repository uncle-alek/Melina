struct SemanticAnalyzerError: Error, Equatable {
    enum ErrorType: Equatable {
        case incompatibleElement
        case incompatibleCondition
        case missingCondition
        case redundantCondition
        case suiteNameCollision
        case scenarioNameCollision
        case subscenarioRecursion
        case subscenarioNameCollision
        case subscenarioDefinitionNotFound
        case jsonNameCollision
        case jsonDefinitionNotFound
        case jsonFileNotFound
        case jsonFileContentHasIncorrectFormat
    }

    let type: ErrorType
    let suite: Token?
    let scenario: Token?
    let action: Token?
    let element: Token?
    let condition: Token?
    let subscenarioDefinition: Token?
    let subscenarioCall: Token?
    let jsonDefinition: Token?
    let jsonReference: Token?
    let jsonFilePath: Token?

    init(
        type: ErrorType,
        suite: Token? = nil,
        scenario: Token? = nil,
        action: Token? = nil,
        element: Token? = nil,
        condition: Token? = nil,
        subscenarioDefinition: Token? = nil,
        subscenarioCall: Token? = nil,
        jsonDefinition: Token? = nil,
        jsonReference: Token? = nil,
        jsonFilePath: Token? = nil
    ) {
        self.type = type
        self.suite = suite
        self.scenario = scenario
        self.action = action
        self.element = element
        self.condition = condition
        self.subscenarioDefinition = subscenarioDefinition
        self.subscenarioCall = subscenarioCall
        self.jsonDefinition = jsonDefinition
        self.jsonReference = jsonReference
        self.jsonFilePath = jsonFilePath
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

    static func redundantCondition(action: Token, condition: Token) -> Self {
        return SemanticAnalyzerError(type: .redundantCondition, action: action, condition: condition)
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

    static func jsonNameCollision(definition: Token) -> Self {
        return SemanticAnalyzerError(type: .jsonNameCollision, jsonDefinition: definition)
    }

    static func jsonDefinitionNotFound(reference: Token) -> Self {
        return SemanticAnalyzerError(type: .jsonDefinitionNotFound, jsonReference: reference)
    }

    static func jsonFileNotFound(filePath: Token) -> Self {
        return SemanticAnalyzerError(type: .jsonFileNotFound, jsonFilePath: filePath)
    }

    static func jsonFileContentHasIncorrectFormat(filePath: Token) -> Self {
        return SemanticAnalyzerError(type: .jsonFileContentHasIncorrectFormat, jsonFilePath: filePath)
    }
}
