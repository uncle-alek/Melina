import Foundation

protocol Node {
    func accept(_ v: Visitor)
}

struct Program: Node, Equatable {
    let suites: [Suite]
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Suite: Node, Equatable {
    let name: Token
    let scenarios: [Scenario]
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Scenario: Node, Equatable {
    let name: Token
    let arguments: [Argument]
    let steps: [Step]
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Argument: Node, Equatable {
    let key: Token
    let value: Token
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Step: Node, Equatable {
    let action: Action
    let element: Element
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Action: Equatable {
    let type: Token
}

struct Element: Equatable {
    let type: Token
    let name: Token
}
