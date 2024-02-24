import Foundation


struct Program: Equatable {
    let suites: [Suite]
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
    let value: Token
}

struct Step: Equatable {
    let action: Action
    let element: Element
}

struct Action: Equatable {
    let type: Token
}

struct Element: Equatable {
    let type: Token
    let name: Token
}
