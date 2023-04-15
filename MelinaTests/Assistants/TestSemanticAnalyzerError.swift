enum TestSemanticAnalyzerError: Error, Equatable {
    case incompatibleAction(element: TestToken, action: TestToken)
}

extension TestSemanticAnalyzerError {
    
    func toSemanticAnalyzerError(
        source: String
    ) -> SemanticAnalyzerError {
        switch self {
        case .incompatibleAction(let element, let action):
            return .incompatibleAction(element: element.toToken(source: source), action: action.toToken(source: source))
        }
    }
}
