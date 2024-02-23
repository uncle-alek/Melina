import Foundation

final class SwiftCodeGenerator: Visitor {
    
    private let program: Program
    private var b = SwiftCodeBuilder()
    private var testClasses: [TestClass] = []
    
    init(
        program: Program
    ) {
        self.program = program
    }
    
    func visit(_ program: Program) {
        program.suites.forEach { suite in
            suite.accept(self)
            testClasses.append(TestClass(name: suite.name.lexeme.fileName, generatedCode: b.result()))
            b = SwiftCodeBuilder()
        }
    }
    
    func visit(_ suite: Suite) {
        b.buildImports()
        b.buildClass(suite: suite) {
            suite.scenarios.forEach { $0.accept(self) }
            b.buildLaunchAppMethod()
        }
        b.buildXCUIElementExtension()
    }
    
    func visit(_ scenario: Scenario) {
        b.buildTestMethod(scenario: scenario) {
            b.buildLaunchAppCall(scenario: scenario) {
                scenario.arguments.forEach { $0.accept(self) }
            }
            scenario.steps.forEach { $0.accept(self) }
        }
    }
    
    func visit(_ argument: Argument) {
        b.buildArgumentPair(argument: argument)
    }
    
    func visit(_ step: Step) {
        b.buildXCTestApiCall(step: step)
    }
    
    func generate() -> Result<Code, [Error]> {
        program.accept(self)
        return .success(Code(testClasses: testClasses))
    }
}
