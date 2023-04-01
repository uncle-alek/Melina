import Foundation

protocol Node {
    func accept(_ v: Visitor)
}

struct Program: Node, Equatable {
    let suites: [Suite]
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Suite: Node, Equatable {
    let name: String
    let scenarios: [Scenario]
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Scenario: Node, Equatable {
    let name: String
    let arguments: [Argument]
    let steps: [Step]
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Argument: Node, Equatable {
    let key: String
    let value: String
    
    func accept(_ v: Visitor) { v.visit(self) }
}

struct Step: Node, Equatable {
    let action: Action
    let elementId: String
    
    func accept(_ v: Visitor) { v.visit(self) }
}

enum Action: Equatable {
    case open
    case tap
    case expect
}
