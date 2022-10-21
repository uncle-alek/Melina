import Foundation

struct Program: Equatable {
    let suites: [Suite]
}

struct Suite: Equatable {
    let name: String
    let scenarios: [Scenario]
}

struct Scenario: Equatable {
    let name: String
    let steps: [Step]
}

struct Step: Equatable {
    let action: Action
    let elementId: String
}

enum Action: Equatable {
    case open
    case tap
    case expect
}
