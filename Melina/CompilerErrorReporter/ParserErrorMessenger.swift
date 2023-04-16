import Foundation

struct ParserErrorMessenger: ErrorMessenger {
    
    func message(for error: ParserError) -> String {
        switch error.expected {
        case .suiteKeyword:           return "expected keyword 'suite' in suite declaration"
        case .suiteName:              return "expected name in suite declaration"
        case .suiteColon:             return "expected ':' in the beggining of suite body"
        case .suiteEnd:               return "expected 'end' at the end of suite body"
        case .scenarioKeyword:        return "expected keyword 'scenario' in scenario declaration"
        case .scenarioName:           return "expected name in scenario declaration"
        case .scenarioColon:          return "expected ':' in the beggining of scenario body"
        case .scenarioEnd:            return "expected 'end' at the end of scenario body"
        case .stepAction:             return "expected action in step"
        case .stepElementName:        return "expected element name in step"
        case .stepElement:            return "expected element type in step"
        case .stepLeftSquareBrace:    return "expected '[' in element body"
        case .stepElementNameKeyword: return "expected 'name' in element body"
        case .stepElementColon:       return "expected ':' in element body"
        case .stepRightSquareBrace:   return "expected expected ']' in element body"
        case .argumentsKeyword:       return "expected keyword 'arguments' in arguments declaration"
        case .argumentsColon:         return "expected ':' in the beggining of arguments body"
        case .argumentsEnd:           return "expected 'end' at the end of arguments body"
        case .argumentKey:            return "expected argument key"
        case .argumentValue:          return "expected argument value"
        case .argumentColon:          return "expected ':' between argument key and value"
        }
    }
}
