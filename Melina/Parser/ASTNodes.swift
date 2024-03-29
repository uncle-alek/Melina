import Foundation


struct Program: Equatable {
    let definitions: [Definition]
}

enum Definition: Equatable {
    case suite(Suite)
    case subscenario(Subscenario)
    case json(JsonDefinition)
}

struct JsonDefinition: Equatable {
    let name: Token
    let filePath: Token
}

struct Subscenario: Equatable {
    let name: Token
    let steps: [Step]
}

struct Suite: Equatable {
    let name: Token
    let scenarios: [Scenario]
}

struct Scenario: Equatable {
    let name: Token
    let arguments: [Argument]
    let steps: [Step]
}

struct Argument: Equatable {
    let key: Token
    let value: ArgumentValue
}

enum ArgumentValue: Equatable {
    case value(Token)
    case jsonReference(JsonReference)
}

struct JsonReference: Equatable {
    let name: Token
}

enum Step: Equatable {
    case action(Action)
    case subscenarioCall(SubscenarioCall)
}

struct Action: Equatable {
    let type: Token
    let element: Element
    let condition: Condition?
}

struct SubscenarioCall: Equatable {
    let name: Token
}

struct Element: Equatable {
    let type: Token
    let name: Token
}

struct Condition: Equatable {
    let type: Token
    let parameter: Token?
}
