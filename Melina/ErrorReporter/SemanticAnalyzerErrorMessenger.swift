struct SemanticAnalyzerErrorMessenger: ErrorMessenger {
 
    func message(for error: SemanticAnalyzerError) -> String {
        switch error {
        case .incompatibleAction(let element, let action): return "action `\(action.lexeme)` can't be applied to the element `\(element.lexeme)`"
        }
    }
}
