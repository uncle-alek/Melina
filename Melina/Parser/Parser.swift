import Foundation

enum ParserError: Error, Equatable {
    case missingStepAction
    case missingStepElementIdentifier
    case missingScenarioKeyword
    case missingScenarioName
    case missingScenarioColon
    case missingSuiteKeyword
    case missingSuiteName
    case missingSuiteColon
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
        let _ = try match(tokenTypes: .suite, error: .missingSuiteKeyword)
        let suiteNameToken = try match(tokenTypes: .string, error: .missingSuiteName)
        let _ = try match(tokenTypes: .colon, error: .missingSuiteColon)
        var scenarios: [Scenario] = []
        while !isAtEnd() {
            if peek().type == .end {
                let _ = advance()
                break
            } else {
                let scenario = try parseScenario()
                scenarios.append(scenario)
            }
        }
        return Suite(
            name: suiteNameToken.lexeme,
            scenarios: scenarios
        )
    }
    
    func parseScenario() throws -> Scenario {
        let _ = try match(tokenTypes: .scenario, error: .missingScenarioKeyword)
        let scenarioNameToken = try match(tokenTypes: .string, error: .missingScenarioName)
        let _ = try match(tokenTypes: .colon, error: .missingScenarioColon)
        var steps: [Step] = []
        while !isAtEnd() {
            if peek().type == .end {
                let _ = advance()
                break
            } else {
                let step = try parseStep()
                steps.append(step)
            }
        }
        return Scenario(
            name: scenarioNameToken.lexeme,
            steps: steps
        )
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
    
    func match(tokenTypes: TokenType..., error: ParserError) throws -> Token {
        let token = advance()
        if tokenTypes.contains(token.type) {
            return token
        } else {
            throw error
        }
    }
    
    func advance() -> Token {
        let token = tokens[currentIndex]
        currentIndex += 1
        return token
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
