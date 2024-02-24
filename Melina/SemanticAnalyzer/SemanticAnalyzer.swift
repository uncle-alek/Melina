enum SemanticAnalyzerError: Error, Equatable {
    case incompatibleAction(action: Token, element: Token)
    case suiteNameCollision(suite: Token)
    case scenarioNameCollision(scenario: Token)
}

fileprivate final class Scope {
    let name: String
    private var symbols: [String] = []
    
    init(
        name: String
    ) {
        self.name = name
    }
    
    func declareSymbol(name: String) {
        symbols.append(name)
    }
    
    func isSymbolDeclared(name: String) -> Bool {
        symbols.contains { $0 == name }
    }
}

final class SemanticAnalyzer {
    
    private let availableActions: [TokenType : [TokenType]] = [
        .tap : [.button],
        .verify : [.button, .label, .textField, .view],
    ]
    
    private var program: Program
    private var errors: [SemanticAnalyzerError] = []
    private var scopes: [Scope] = []
    
    init(
        program: Program
    ) {
        self.program = program
    }

    func analyze() -> Result<Program, [Error]> {
        analyzeProgram(program)
        if errors.isEmpty {
            return .success(program)
        } else {
            return .failure(errors)
        }
    }
}

private extension SemanticAnalyzer {

    func analyzeProgram(_ program: Program) {
        scopes.append(Scope(name: "Global"))
        program.definitions.forEach(analyzeDefinition)
        _ = scopes.popLast()
    }

    func analyzeDefinition(_ definition: Definition) {
        switch definition {
        case .subscenario(let value): analyzeSubscenario(value)
        case .suite(let value): analyzeSuite(value)
        }
    }

    func analyzeSubscenario(_ subscenario: Subscenario) {}

    func analyzeSuite(_ suite: Suite) {
        let currentScope = scopes.last!
        if currentScope.isSymbolDeclared(name: suite.name.lexeme) {
            errors.append(.suiteNameCollision(suite: suite.name))
        } else {
            currentScope.declareSymbol(name: suite.name.lexeme)
        }

        scopes.append(Scope(name: suite.name.lexeme))
        suite.scenarios.forEach(analyzeScenario)
        _ = scopes.popLast()
    }

    func analyzeScenario(_ scenario: Scenario) {
        let currentScope = scopes.last!
        if currentScope.isSymbolDeclared(name: scenario.name.lexeme) {
            errors.append(.scenarioNameCollision(scenario: scenario.name))
        } else {
            currentScope.declareSymbol(name: scenario.name.lexeme)
        }

        scenario.arguments.forEach(analyzeArument)
        scenario.steps.forEach(analyzeStep)
    }

    func analyzeArument(_ argument: Argument) {}

    func analyzeStep(_ step: Step) {
        switch step {
        case .action(let value): analyzeAction(value)
        case .subscenarioCall(let value): analyzeSubscenarioCall(value)
        }
    }

    func analyzeAction(_ action: Action) {
        if !availableActions[action.type.type]!.contains(action.element.type.type) {
            errors.append(.incompatibleAction(action: action.type, element: action.element.type))
        }
    }

    func analyzeSubscenarioCall(_ subscenarioCall: SubscenarioCall) {}
}
