import Foundation

struct ParserError: Error, Equatable {
    
    let expected: Expected
    let line: Int
    let index: String.Index
    
    enum Expected: Equatable {
        case suiteKeyword,
             suiteName,
             suiteColon,
             suiteEnd
        
        case scenarioKeyword,
             scenarioName,
             scenarioColon,
             scenarioEnd
        
        case stepAction,
             stepElementIdentifier,
             stepElement
        
        case argumentsKeyword,
             argumentsColon,
             argumentsEnd
        
        case argumentKey,
             argumentValue,
             argumentColon
    }
}

final class Parser {
    
    private let tokens: [Token]
    private var currentIndex: Int = 0
    private var suites: [Suite] = []
    private var errors: [Error] = []
    
    init(
        tokens: [Token]
    ) {
        self.tokens = tokens
    }
    
    func parse() -> Result<Program, [Error]> {
        var suites: [Suite] = []
        while !isAtEnd() {
            do {
                let suite = try parseSuite()
                suites.append(suite)
            } catch {
                errors.append(error)
                break
            }
        }
        if errors.isEmpty {
            return .success(Program(suites: suites))
        } else {
            return .failure(errors)
        }
        
    }
}

private extension Parser {
    
    func parseSuite() throws -> Suite  {
        try match(tokenTypes: .suite, error: .suiteKeyword)
        let suiteNameToken = try match(tokenTypes: .string, error: .suiteName)
        try match(tokenTypes: .colon, error: .suiteColon)
        let scenarios = try parseScenarios()
        try match(tokenTypes: .end, error: .suiteEnd)
        return Suite(
            name: suiteNameToken,
            scenarios: scenarios
        )
    }
    
    func parseScenarios() throws -> [Scenario] {
        var scenarios: [Scenario] = []
        while !isAtScopeEnd() {
            let scenario = try parseScenario()
            scenarios.append(scenario)
        }
        return scenarios
    }
    
    func parseScenario() throws -> Scenario {
        try match(tokenTypes: .scenario, error: .scenarioKeyword)
        let scenarioNameToken = try match(tokenTypes: .string, error: .scenarioName)
        try match(tokenTypes: .colon, error: .scenarioColon)
        let arguments = check(tokenTypes: .arguments) ? try parseArguments() : []
        let steps = try parseSteps()
        try match(tokenTypes: .end, error: .scenarioEnd)
        return Scenario(
            name: scenarioNameToken,
            arguments: arguments,
            steps: steps
        )
    }
    
    func parseArguments() throws -> [Argument] {
        try match(tokenTypes: .arguments, error: .argumentsKeyword)
        try match(tokenTypes: .colon, error: .argumentsColon)
        let argumentsBody = try parseArgumentsBody()
        try match(tokenTypes: .end, error: .argumentsEnd)
        return argumentsBody
    }
    
    func parseArgumentsBody() throws -> [Argument] {
        var arguments: [Argument] = []
        let argument = try parseArgument()
        arguments.append(argument)
        while !isAtScopeEnd() {
            let argument = try parseArgument()
            arguments.append(argument)
        }
        return arguments
    }
    
    func parseArgument() throws -> Argument {
        let keyToken = try match(tokenTypes: .string, error: .argumentKey)
        try match(tokenTypes: .colon, error: .argumentColon)
        let valueToken = try match(tokenTypes: .string, error: .argumentValue)
        return Argument(
            key: keyToken,
            value: valueToken
        )
    }
    
    func parseSteps() throws -> [Step] {
        var steps: [Step] = []
        let step = try parseStep()
        steps.append(step)
        while !isAtScopeEnd() {
            let step = try parseStep()
            steps.append(step)
        }
        return steps
    }
    
    func parseStep() throws -> Step {
        let actionToken = try match(tokenTypes: .tap, .verify, .scrollUp, .scrollDown, error: .stepAction)
        let elementIdToken = try match(tokenTypes: .string, error: .stepElementIdentifier)
        let elementToken = try match(tokenTypes: .button, .text, .searchField, error: .stepElement)
        return Step(
            action: actionToken,
            elementId: elementIdToken,
            element: elementToken
        )
    }
}

private extension Parser {
    
    func isAtScopeEnd() -> Bool {
        isAtEnd() || peek().type == .end
    }
    
    func isAtEnd() -> Bool {
        tokens[currentIndex].type == .eof
    }
    
    @discardableResult
    func match(tokenTypes: TokenType..., error: ParserError.Expected) throws -> Token {
        let token = advance()
        if tokenTypes.contains(token.type) {
            return token
        } else {
            throw ParserError(
                expected: error,
                line: tokens[currentIndex - 1].line,
                index: tokens[currentIndex - 1].startIndex
            )
        }
    }
    
    @discardableResult
    func advance() -> Token {
        let token = tokens[currentIndex]
        currentIndex += 1
        return token
    }
    
    func check(tokenTypes: TokenType...) -> Bool {
        tokenTypes.contains(peek().type)
    }
    
    func peek() -> Token {
        tokens[currentIndex]
    }
}
