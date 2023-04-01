protocol Visitor {
    func visit(_ program: Program)
    func visit(_ suite: Suite)
    func visit(_ scenario: Scenario)
    func visit(_ step: Step)
}
