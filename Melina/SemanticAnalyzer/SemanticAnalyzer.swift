final class SemanticAnalyzer {
    
    private let compatibleElements: [TokenType : [TokenType]] = [
        .tap    : [.button],
        .verify : [.button, .label, .textField, .view],
        .edit   : [.textField]
    ]

    private let compatibleConditions: [TokenType : [TokenType]] = [
        .tap    : [],
        .verify : [.isExist, .isNotExist, .isSelected, .isNotSelected, .containsValue],
        .edit   : [.withText]
    ]

    private let conditionsWithParameters: [TokenType] = [
        .containsValue,
        .withText
    ]

    private var program: Program
    private var errors: [SemanticAnalyzerError] = []
    private var scopeStack: [Scope] = []
    private var globalScope: Scope!

    init(
        program: Program
    ) {
        self.program = program
    }

    func analyze() -> Result<Program, [Error]> {
        registerSymbols(program)
        analyzeProgram(program)
        if errors.isEmpty {
            return .success(program)
        } else {
            return .failure(errors)
        }
    }
}

private extension SemanticAnalyzer {

    func registerSymbols(_ program: Program) {
        self.globalScope = Scope(parentScope: nil, type: .global, name: "Global")
        program.definitions.forEach { registerDefinition($0, parentScope: self.globalScope) }
    }

    func registerDefinition(_ definition: Definition, parentScope: Scope) {
        switch definition {
        case .subscenario(let value): registerSubscenario(value, parentScope: self.globalScope)
        case .suite(let value): registerSuite(value, parentScope: self.globalScope)
        case .json(let value): registerJson(value, parentScope: self.globalScope)
        }
    }

    func registerSubscenario(_ subscenario: Subscenario, parentScope: Scope) {
        parentScope.declareSymbol(Symbol(type: .subscenario, name: subscenario.name))
        let newScope = Scope(parentScope: parentScope, type: .subscenario, name: subscenario.name.lexeme)
        parentScope.childScopes.append(newScope)
    }

    func registerSuite(_ suite: Suite, parentScope: Scope) {
        parentScope.declareSymbol(Symbol(type: .suite, name: suite.name))
        let newScope = Scope(parentScope: parentScope, type: .suite, name: suite.name.lexeme)
        suite.scenarios.forEach { registerScenario($0, parentScope: newScope) }
        parentScope.childScopes.append(newScope)
    }

    func registerJson(_ json: JsonDefinition, parentScope: Scope) {
        let newScope = Scope(parentScope: parentScope, type: .dummy, name: json.name.lexeme)
        parentScope.declareSymbol(Symbol(type: .json, name: json.name))
        parentScope.childScopes.append(newScope)
    }

    func registerScenario(_ scenario: Scenario, parentScope: Scope) {
        parentScope.declareSymbol(Symbol(type: .scenario, name: scenario.name))
    }
}

private extension SemanticAnalyzer {

    func analyzeProgram(_ program: Program) {
        scopeStack.append(self.globalScope)
        for (index, definition) in program.definitions.enumerated() {
            analyzeDefinition(definition, scope: scopeStack.last!.childScopes[index])
        }
        _ = scopeStack.popLast()
    }

    func analyzeDefinition(_ definition: Definition, scope: Scope) {
        switch definition {
        case .subscenario(let value): analyzeSubscenario(value, scope: scope)
        case .suite(let value): analyzeSuite(value, scope: scope)
        case .json(let value): analyzeJson(value, scope: scope)
        }
    }

    func analyzeSubscenario(_ subscenario: Subscenario, scope: Scope) {
        analyzeSubscenarioForRecursion(subscenario)
        analyzeSubscenarioForNameCollision(subscenario)

        scopeStack.append(scope)
        subscenario.steps.forEach(analyzeStep)
        _ = scopeStack.popLast()
    }

    func analyzeSuite(_ suite: Suite, scope: Scope) {
        analyzeSuiteForNameCollision(suite)

        scopeStack.append(scope)
        suite.scenarios.forEach(analyzeScenario)
        _ = scopeStack.popLast()
    }

    func analyzeJson(_ json: JsonDefinition, scope: Scope) {
        analyzeJsonForNameCollision(json)
    }

    func analyzeScenario(_ scenario: Scenario) {
        analyzeScenarioForNameCollision(scenario)

        scenario.arguments.forEach(analyzeArument)
        scenario.steps.forEach(analyzeStep)
    }

    func analyzeArument(_ argument: Argument) {
        switch argument.value {
        case .value(_): break
        case .jsonReference(let v): analyzeJsonReference(v)
        }
    }

    func analyzeStep(_ step: Step) {
        switch step {
        case .action(let value): analyzeAction(value)
        case .subscenarioCall(let value): analyzeSubscenarioCall(value)
        }
    }

    func analyzeAction(_ action: Action) {
        analyzeCompatilityWithElement(action)
        analyzeCompatibilityWithCondition(action)
        analyzeMissingCondition(action)
        analyzeRedundantCondition(action)
    }

    func analyzeSubscenarioCall(_ subscenarioCall: SubscenarioCall) {
        analyzeForSubscenarioDefinition(subscenarioCall)
    }

    func analyzeJsonReference(_ jsonReference: JsonReference) {
        analyzeForJsonDefinition(jsonReference)
    }
}

private extension SemanticAnalyzer {

    func analyzeSubscenarioForNameCollision(_ subscenario: Subscenario) {
        if scopeStack.last!.isSymbolCollided(Symbol(type: .subscenario, name: subscenario.name)) {
            errors.append(.subscenarioNameCollision(definition: subscenario.name))
        }
    }

    func analyzeScenarioForNameCollision(_ scenario: Scenario) {
        if scopeStack.last!.isSymbolCollided(Symbol(type: .scenario, name: scenario.name)) {
            errors.append(.scenarioNameCollision(scenario: scenario.name))
        }
    }

    func analyzeSuiteForNameCollision(_ suite: Suite) {
        if scopeStack.last!.isSymbolCollided(Symbol(type: .suite, name: suite.name)) {
            errors.append(.suiteNameCollision(suite: suite.name))
        }
    }

    func analyzeJsonForNameCollision(_ json: JsonDefinition) {
        if scopeStack.last!.isSymbolCollided(Symbol(type: .json, name: json.name)) {
            errors.append(.jsonNameCollision(definition: json.name))
        }
    }

    func analyzeCompatilityWithElement(_ action: Action) {
        guard let elements = compatibleElements[action.type.type] else {
            fatalError("All actions should be register in compatible elements table")
        }
        if !elements.contains(action.element.type.type) {
            errors.append(
                .incompatibleElement(
                    action: action.type,
                    element: action.element.type
                )
            )
        }
    }

    func analyzeCompatibilityWithCondition(_ action: Action) {
        guard let conditions = compatibleConditions[action.type.type] else {
            fatalError("All actions should be register in compatible conditions table")
        }
        guard !conditions.isEmpty else { return }

        if let condition = action.condition {
            if !conditions.contains(condition.type.type) {
                errors.append(
                    .incompatibleCondition(
                        action: action.type,
                        condition: condition.type
                    )
                )
            }
        }
    }

    func analyzeMissingCondition(_ action: Action) {
        guard let conditions = compatibleConditions[action.type.type] else {
            fatalError("All actions should be register in compatible conditions table")
        }
        guard !conditions.isEmpty else { return }

        if action.condition == nil {
            errors.append(
                .missingCondition(
                    action: action.type
                )
            )
        }
    }

    func analyzeRedundantCondition(_ action: Action) {
        guard let conditions = compatibleConditions[action.type.type] else {
            fatalError("All actions should be register in compatible conditions table")
        }
        if action.condition != nil && conditions.isEmpty {
            errors.append(
                .redundantCondition(
                    action: action.type,
                    condition: action.condition!.type
                )
            )
        }
    }

    func analyzeSubscenarioForRecursion(_ subscenario: Subscenario) {
        for step in subscenario.steps {
            switch step {
            case .action(_): continue
            case .subscenarioCall(let value):
                if value.name.lexeme == subscenario.name.lexeme {
                    errors.append(
                        .subscenarioRecursion(
                            definition: subscenario.name,
                            call: value.name
                        )
                    )
                }
            }
        }
    }

    func analyzeForSubscenarioDefinition(_ subscenarioCall: SubscenarioCall) {
        var isDefinitionFound = false
        var currentScope = scopeStack.last
        while currentScope != nil {
            if currentScope!.isSymbolDeclared(type: .subscenario, name: subscenarioCall.name.lexeme) {
                isDefinitionFound = true
            }
            currentScope = currentScope?.parentScope
        }
        if isDefinitionFound == false {
            errors.append(.subscenarioDefinitionNotFound(call: subscenarioCall.name))
        }
    }

    func analyzeForJsonDefinition(_ jsonReference: JsonReference) {
        var isDefinitionFound = false
        var currentScope = scopeStack.last
        while currentScope != nil {
            if currentScope!.isSymbolDeclared(type: .json, name: jsonReference.name.lexeme) {
                isDefinitionFound = true
            }
            currentScope = currentScope?.parentScope
        }
        if isDefinitionFound == false {
            errors.append(.jsonDefinitionNotFound(reference: jsonReference.name))
        }
    }
}
