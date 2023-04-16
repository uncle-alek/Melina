enum SemanticAnalyzerError: Error, Equatable {
    case incompatibleAction(action: Token, element: Token)
    case suiteNameCollision(suite: Token)
    case scenarioNameCollision(scenario: Token)
}

final class Scope {
    let name: String
    var symbols: [String] = []
    
    init(
        name: String
    ) {
        self.name = name
    }
}

final class SemanticAnalyzer: Visitor {
    
    private let availableActions: [TokenType : [TokenType]] = [
        .tap : [.button],
        .verify : [.button, .searchField, .text],
    ]
    
    private var program: Program
    private var errors: [SemanticAnalyzerError] = []
    private var scopes: [Scope] = []
    
    init(
        program: Program
    ) {
        self.program = program
    }
    
    func visit(_ program: Program) {
        scopes.append(Scope(name: "global"))
        program.suites.forEach { $0.accept(self) }
        _ = scopes.popLast()
    }
    
    func visit(_ suite: Suite) {
        let currentScope = scopes.last
        let isNameCollisionDetected = currentScope!.symbols.contains { $0 == suite.name.lexeme }
        if isNameCollisionDetected {
            errors.append(.suiteNameCollision(suite: suite.name))
        }
        currentScope?.symbols.append(suite.name.lexeme)
        
        scopes.append(Scope(name: suite.name.lexeme))
        suite.scenarios.forEach { $0.accept(self) }
        _ = scopes.popLast()
    }
    
    func visit(_ scenario: Scenario) {
        let currentScope = scopes.last
        let isNameCollisionDetected = currentScope!.symbols.contains { $0 == scenario.name.lexeme }
        if isNameCollisionDetected {
            errors.append(.scenarioNameCollision(scenario: scenario.name))
        }
        currentScope?.symbols.append(scenario.name.lexeme)
        
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
