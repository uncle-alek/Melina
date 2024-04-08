import Foundation

struct ParserError: Error, Equatable {
    
    let expected: Expected
    let line: Int
    let index: String.Index
    
    enum Expected: Equatable {
        case definition,
             step

        case subscenarioDefinitionName,
             subscenarioCallName

        case jsonDefinitionName,
             jsonFile,
             jsonFilePath,
             jsonReferenceName

        case suiteName

        case scenario,
             scenarioName

        case argumentKey,
             argumentTo,
             argumentValue

        case elementType,
             elementName

        case colon,
             end
    }
}

private var actionTypes: [TokenType] = [
    .tap,
    .verify,
    .edit
]
private var elementTypes: [TokenType] = [
    .button,
    .view,
    .textField,
    .label
]
private var conditionTypes: [TokenType] = [
    .selected,
    .notSelected,
    .exists,
    .notExists,
    .contains,
    .with
]

final class Parser {
    
    private let tokens: [Token]
    private var currentIndex: Int = 0
    private var suites: [Suite] = []

    init(
        tokens: [Token]
    ) {
        self.tokens = tokens
    }
    
    func parse() -> Result<Program, [Error]> {
        do {
            return .success(try parseProgram())
        } catch {
            return .failure([error])
        }
    }
}

private extension Parser {

    func parseProgram() throws -> Program {
        var definitions: [Definition] = []
        let mandatoryDefinition = try parseDefinition()
        definitions.append(mandatoryDefinition)

        while !isAtEnd() {
            let definition = try parseDefinition()
            definitions.append(definition)
        }
        return Program(
            definitions: definitions
        )
    }

    func parseDefinition() throws -> Definition {
        if check(tokenType: .suite) {
            return .suite(try parseSuiteDefinition())
        } else if check(tokenType: .subscenario) {
            return .subscenario(try parseSubscenarioDefinition())
        } else if check(tokenType: .json) {
            return .json(try parseJsonDefinition())
        } else {
            throw parseError(expected: .definition)
        }
    }

    func parseSuiteDefinition() throws -> Suite  {
        advance()
        let suiteName = try match(tokenType: .string, error: .suiteName)
        try match(tokenType: .colon, error: .colon)
        let scenarios = try parseScenarios()
        try match(tokenType: .end, error: .end)
        return Suite(
            name: suiteName,
            scenarios: scenarios
        )
    }

    func parseSubscenarioDefinition() throws -> Subscenario  {
        advance()
        let name = try match(tokenType: .string, error: .subscenarioDefinitionName)
        try match(tokenType: .colon, error: .colon)
        let steps = try parseSteps()
        try match(tokenType: .end, error: .end)
        return Subscenario(
            name: name,
            steps: steps
        )
    }

    func parseJsonDefinition() throws -> JsonDefinition {
        advance()
        let name = try match(tokenType: .string, error: .jsonDefinitionName)
        try match(tokenType: .colon, error: .colon)
        try match(tokenType: .file, error: .jsonFile)
        let filePath = try match(tokenType: .string, error: .jsonFilePath)
        try match(tokenType: .end, error: .end)
        return JsonDefinition(
            name: name,
            filePath: filePath
        )
    }

    func parseScenarios() throws -> [Scenario] {
        var scenarios: [Scenario] = []
        let mandatoryScenario = try parseScenario()
        scenarios.append(mandatoryScenario)

        while !isAtScopeEnd() {
            let scenario = try parseScenario()
            scenarios.append(scenario)
        }
        return scenarios
    }
    
    func parseScenario() throws -> Scenario {
        try match(tokenType: .scenario, error: .scenario)
        let scenarioName = try match(tokenType: .string, error: .scenarioName)
        try match(tokenType: .colon, error: .colon)
        let arguments = check(tokenTypes: [.arguments])
            ? try parseArguments()
            : []
        let steps = try parseSteps()
        try match(tokenType: .end, error: .end)
        return Scenario(
            name: scenarioName,
            arguments: arguments,
            steps: steps
        )
    }
    
    func parseArguments() throws -> [Argument] {
        advance()
        try match(tokenType: .colon, error: .colon)
        let argumentsBody = try parseArgumentsBody()
        try match(tokenType: .end, error: .end)
        return argumentsBody
    }
    
    func parseArgumentsBody() throws -> [Argument] {
        var arguments: [Argument] = []
        let mandatoryArgument = try parseArgument()
        arguments.append(mandatoryArgument)

        while !isAtScopeEnd() {
            let argument = try parseArgument()
            arguments.append(argument)
        }
        return arguments
    }
    
    func parseArgument() throws -> Argument {
        let key = try match(tokenType: .string, error: .argumentKey)
        try match(tokenType: .to, error: .argumentTo)
        let value = try parseArgumentValue()
        return Argument(
            key: key,
            value: value
        )
    }

    func parseArgumentValue() throws -> ArgumentValue {
        if check(tokenType: .string) {
            return .value(advance())
        } else if check(tokenType: .json) {
            return .jsonReference(try parseJsonReference())
        } else {
            throw parseError(expected: .argumentValue)
        }
    }

    func parseJsonReference() throws -> JsonReference {
        advance()
        let name = try match(tokenType: .string, error: .jsonReferenceName)
        return JsonReference(
            name: name
        )
    }

    func parseSteps() throws -> [Step] {
        var steps: [Step] = []
        let mandatoryStep = try parseStep()
        steps.append(mandatoryStep)

        while !isAtScopeEnd() {
            let step = try parseStep()
            steps.append(step)
        }
        return steps
    }
    
    func parseStep() throws -> Step {
        if check(tokenType: .subscenario) {
            return .subscenarioCall(try parseSubscenarioCall())
        } else if check(tokenTypes: actionTypes) {
            return .action(try parseAction())
        } else {
            throw parseError(expected: .step)
        }
    }

    func parseSubscenarioCall() throws -> SubscenarioCall {
        advance()
        let name = try match(tokenType: .string, error: .subscenarioCallName)
        return SubscenarioCall(
            name: name
        )
    }

    func parseAction() throws -> Action {
        let type = advance()
        let element = try parseElement()
        let condition = check(tokenTypes: conditionTypes)
            ? try parseCondition()
            : nil
        return Action(
            type: type,
            element: element,
            condition: condition
        )
    }
    
    func parseElement() throws -> Element {
        let type = try match(tokenTypes: elementTypes, error: .elementType)
        let name = try match(tokenType: .string, error: .elementName)
        return Element(
            type: type,
            name: name
        )
    }

    func parseCondition() throws -> Condition {
        let type = advance()
        let parameter = check(tokenType: .string)
            ? advance()
            : nil
        return Condition(
            type: type,
            parameter: parameter
        )
    }
}

private extension Parser {
    
    func isAtScopeEnd() -> Bool {
        return isAtEnd() || peek().type == .end
    }
    
    func isAtEnd() -> Bool {
        return tokens[currentIndex].type == .eof
    }
    
    @discardableResult
    func match(tokenTypes: [TokenType], error: ParserError.Expected) throws -> Token {
        let token = advance()
        if tokenTypes.contains(token.type) {
            return token
        } else {
            throw parseError(expected: error)
        }
    }

    @discardableResult
    func match(tokenType: TokenType, error: ParserError.Expected) throws -> Token {
        let token = advance()
        if tokenType == token.type {
            return token
        } else {
            throw parseError(expected: error)
        }
    }

    @discardableResult
    func advance() -> Token {
        let token = tokens[currentIndex]
        currentIndex += 1
        return token
    }

    func check(tokenType: TokenType) -> Bool {
        return tokenType == peek().type
    }

    func check(tokenTypes: [TokenType]) -> Bool {
        return tokenTypes.contains(peek().type)
    }
    
    func peek() -> Token {
        return tokens[currentIndex]
    }

    func parseError(expected: ParserError.Expected) -> ParserError {
        let line = currentIndex != 0 ? tokens[currentIndex - 1].line : 0
        let index = currentIndex != 0 ? tokens[currentIndex - 1].startIndex : "".startIndex
        return ParserError(
            expected: expected,
            line: line,
            index: index
        )
    }
}
