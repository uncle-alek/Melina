import Foundation

enum ParserError: Error, Equatable {
    case missingStepAction
    case missingStepElementIdentifier
    case missingScenarioKeyword
    case missingScenarioName
    case missingSuiteKeyword
    case missingSuiteName
    case missingArgumentsKey
    case missingArgumentsValue
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
        return Suite(
            name: suiteNameToken.lexeme,
            scenarios: scenarios
        )
    }
    
    func parseScenarios() throws -> [Scenario] {
        var scenarios: [Scenario] = []
        while !isAtEnd() {
            if peek().type == .end {
                advance()
                break
            } else {
                let scenario = try parseScenario()
                scenarios.append(scenario)
            }
        }
        return scenarios
    }
    
    func parseScenario() throws -> Scenario {
        try match(tokenTypes: .scenario, error: .missingScenarioKeyword)
        let scenarioNameToken = try match(tokenTypes: .string, error: .missingScenarioName)
        try match(tokenTypes: .colon, error: .missingColon)
        let arguments = try parseArguments()
        let steps = try parseSteps()
        return Scenario(
            name: scenarioNameToken.lexeme,
            arguments: arguments,
            steps: steps
        )
    }
    
    func parseArguments() throws -> [Argument] {
        guard check(tokenTypes: .arguments) else { return [] }
        advance()
        try match(tokenTypes: .colon, error: .missingColon)
        var arguments: [Argument] = []
        while !isAtEnd() {
            if peek().type == .end {
                advance()
                break
            } else {
                let argument = try parseArgument()
                arguments.append(argument)
            }
        }
        return arguments
    }
    
    func parseArgument() throws -> Argument {
        let keyToken = try match(tokenTypes: .string, error: .missingArgumentsKey)
        try match(tokenTypes: .colon, error: .missingColon)
        let valueToken = try match(tokenTypes: .string, error: .missingArgumentsValue)
        return Argument(
            key: keyToken.lexeme,
            value: valueToken.lexeme
        )
    }
    
    func parseSteps() throws -> [Step] {
        var steps: [Step] = []
        while !isAtEnd() {
            if peek().type == .end {
                advance()
                break
            } else {
                let step = try parseStep()
                steps.append(step)
            }
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
