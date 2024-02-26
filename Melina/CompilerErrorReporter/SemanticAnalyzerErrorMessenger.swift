struct SemanticAnalyzerErrorMessenger: ErrorMessenger {
 
    func message(for error: SemanticAnalyzerError) -> String {
        switch error.type {
        case .incompatibleElement:
            return "Action `\(error.action!.lexeme)` can't be applied to the element `\(error.element!.lexeme)`."
        case .suiteNameCollision:
            return "A suite with the name `\(error.suite!.lexeme)` is already defined."
        case .scenarioNameCollision:
            return "A scenario with the name `\(error.scenario!.lexeme)` is already defined."
        case .missingCondition:
            return "The action `\(error.action!.lexeme)` requires a condition at the end of the step."
        case .incompatibleCondition:
            return "The condition `\(error.condition!.lexeme)` is not compatible with the action `\(error.action!.lexeme)`."
        case .subscenarioRecursion:
            return "Recursion detected: The subscenario `\(error.subscenarioCall!.lexeme)` cannot invoke itself."
        case .subscenarioNameCollision:
            return "A subscenario with the name `\(error.subscenarioDefinition!.lexeme)` is already defined."
        case .subscenarioDefinitionNotFound:
            return "The definition for the subscenario `\(error.subscenarioCall!.lexeme)` was not found."
        }
    }
}
