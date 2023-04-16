import Foundation

final class ASTPrinter: Visitor {
    
    private var formattedText: String = ""
    private let program: Program
    
    init(
        program: Program
    ) {
        self.program = program
    }
    
    func visit(_ program: Program) {
        formattedText += "<Program_beggining>" + "\n"
        program.suites.forEach { suite in
            suite.accept(self)
        }
        formattedText += "<Program_end>"
    }
    
    func visit(_ suite: Suite) {
        formattedText += "<Suite_beggining>:\(suite.name.lexeme)" + "\n"
        suite.scenarios.forEach { $0.accept(self) }
        formattedText += "<Suite_end>" + "\n"
    }
    
    func visit(_ scenario: Scenario) {
        formattedText += "<Scenario_begging>:\(scenario.name.lexeme)" + "\n"
        if !scenario.arguments.isEmpty {
            formattedText += "Arguments:["
            scenario.arguments.forEach { arg in
                arg.accept(self)
                if arg != scenario.arguments.last {
                    formattedText += ","
                }
            }
            formattedText += "]" + "\n"
        }
        formattedText += "Steps:["
        scenario.steps.forEach { step in
            step.accept(self)
            if step != scenario.steps.last {
                formattedText += ","
            }
        }
        formattedText += "]" + "\n"
        formattedText += "<Scenario_end>" + "\n"
    }
    
    func visit(_ argument: Argument) {
        formattedText += "\(argument.key.lexeme):\(argument.value.lexeme)"
    }
    
    func visit(_ step: Step) {
        formattedText += "\(step.action.type.lexeme)-\(step.element.type.lexeme)[name:\(step.element.name.lexeme)]"
    }
    
    func toString() -> String {
        program.accept(self)
        return formattedText
    }
}
