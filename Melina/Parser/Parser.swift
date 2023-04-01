import Foundation

enum ParserError: Error, Equatable {
    case missingStepAction
    case missingStepElementIdentifier
    case missingScenarioKeyword
    case missingScenarioName
    case missingSuiteKeyword
    case missingSuiteName
    case missingArgumentsKeyword
    case missingArgumentKey
    case missingArgumentValue
    case missingEnd
    case missingColon
}

final class Parser {
    
    private let tokens: [Token]
    private var currentIndex: Int = 0
    private var suites: [Suite] = []
    
    init(
        tokens: [Token]
    ) {
        self.tokens = tokens
    }
    
    func parse() throws -> Program {
        var suites: [Suite] = []
        while !isAtEnd() {
            let suite = try parseSuite()
            suites.append(suite)
        }
        return Program(suites: suites)
    }
}

private extension Parser {
    
    func parseSuite() throws -> Suite  {
        try match(tokenTypes: .suite, error: .missingSuiteKeyword)
        let suiteNameToken = try match(tokenTypes: .string, error: .missingSuiteName)
        try match(tokenTypes: .colon, error: .missingColon)
        let scenarios = try parseScenarios()
        try match(tokenTypes: .end, error: .missingEnd)
        return Suite(
            name: suiteNameToken.lexeme,
            scenarios: scenarios
        )
    }
    
    func parseScenarios() throws -> [Scenario] {
        var scenarios: [Scenario] = []
        while !isAtEnd() && peek().type != .end {
            let scenario = try parseScenario()
            scenarios.append(scenario)
        }
        return scenarios
    }
    
    func parseScenario() throws -> Scenario {
        try match(tokenTypes: .scenario, error: .missingScenarioKeyword)
        let scenarioNameToken = try match(tokenTypes: .string, error: .missingScenarioName)
        try match(tokenTypes: .colon, error: .missingColon)
        let arguments = check(tokenTypes: .arguments) ? try parseArguments() : []
        let steps = try parseSteps()
        try match(tokenTypes: .end, error: .missingEnd)
        return Scenario(
            name: scenarioNameToken.lexeme,
            arguments: arguments,
            steps: steps
        )
    }
    
    func parseArguments() throws -> [Argument] {
        try match(tokenTypes: .arguments, error: .missingArgumentsKeyword)
        try match(tokenTypes: .colon, error: .missingColon)
        let argumentsBody = try parseArgumentsBody()
        try match(tokenTypes: .end, error: .missingEnd)
        return argumentsBody
    }
    
    func parseArgumentsBody() throws -> [Argument] {
        var arguments: [Argument] = []
        while !isAtEnd() && peek().type != .end {
            let argument = try parseArgument()
            arguments.append(argument)
        }
        return arguments
    }
    
    func parseArgument() throws -> Argument {
        let keyToken = try match(tokenTypes: .string, error: .missingArgumentKey)
        try match(tokenTypes: .colon, error: .missingColon)
        let valueToken = try match(tokenTypes: .string, error: .missingArgumentValue)
        return Argument(
            key: keyToken.lexeme,
            value: valueToken.lexeme
        )
    }
    
    func parseSteps() throws -> [Step] {
        var steps: [Step] = []
        while !isAtEnd() && peek().type != .end {
            let step = try parseStep()
            steps.append(step)
        }
        return steps
    }
    
    func parseStep() throws -> Step {
        let actionToken = try match(tokenTypes: .tap, .open, .expect, error: .missingStepAction)
        let elementIdToken = try match(tokenTypes: .string, error: .missingStepElementIdentifier)
        return Step(
            action: actionToken.type.action!,
            elementId: elementIdToken.lexeme
        )
    }
}

private extension Parser {
    
    func isAtEnd() -> Bool {
        tokens[currentIndex].type == .eof
    }
    
    @discardableResult
    func match(tokenTypes: TokenType..., error: ParserError) throws -> Token {
        let token = advance()
        if tokenTypes.contains(token.type) {
            return token
        } else {
            throw error
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

extension TokenType {
    
    var action: Action? {
        switch self {
        case .tap: return .tap
        case .expect: return .expect
        case .open: return .open
        default: return nil
        }
    }
}
