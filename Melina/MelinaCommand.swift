import ArgumentParser

struct Melina: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "melina",
        abstract: "Code generator for UITests."
    )

    @Option(
        name: [.customShort("p"), .customLong("path")],
        help: "The path to the test specification."
    )
    var path: String

    mutating func run() throws {
        let sourceCode = try FileService().content(at: path)
        let reporter = ErrorReporter(filePath: path, source: sourceCode)
        do {
            let tokens = try Lexer(source: sourceCode).tokenize()
            let program = try Parser(tokens: tokens).parse()
            let swiftCode = SwiftCodeGenerator(program: program).generate()
            try swiftCode.testClasses.forEach { try FileService().write(content: $0.generatedCode, with: $0.name) }
        } catch {
            reporter.report(error: error)
        }
    }
}
