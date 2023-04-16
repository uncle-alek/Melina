enum SemanticAnalyzerError: Error, Equatable {
    case incompatibleAction(action: Token, element: Token)
}

final class SemanticAnalyzer: Visitor {
    
    private let availableActions: [TokenType : [TokenType]] = [
        .tap : [.button],
        .verify : [.button, .searchField, .text],
    ]
    
    private var program: Program
    private var errors: [SemanticAnalyzerError] = []
    
    init(
        program: Program
    ) {
        self.program = program
    }
    
    func visit(_ program: Program) {
        program.suites.forEach { $0.accept(self) }
    }
    
    func visit(_ suite: Suite) {
        suite.scenarios.forEach { $0.accept(self) }
    }
    
    func visit(_ scenario: Scenario) {
        scenario.arguments.forEach { $0.accept(self) }
        scenario.steps.forEach { $0.accept(self) }
    }
    
    func visit(_ argument: Argument) {}
    
    func visit(_ step: Step) {
        if !availableActions[step.action.type.type]!.contains(step.element.type.type) {
            errors.append(.incompatibleAction(action: step.action.type, element: step.element.type))
        }
    }
    
    func analyze() -> Result<Program, [Error]> {
        program.accept(self)
        if errors.isEmpty {
            return .success(program)
        } else {
            return .failure(errors)
        }
    }
}
