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
    var sourceCode: String = ""

    mutating func run() throws {
        do {
            sourceCode = try FileService().content(at: path)
            let tokens = try Lexer(source: sourceCode).tokenize()
            let program = try Parser(tokens: tokens).parse()
            let swiftCode = SwiftCodeGenerator(program: program).generate()
            try swiftCode.testClasses.forEach { try FileService().write(content: $0.generatedCode, with: $0.name) }
        } catch {
            ErrorReporter(
                filePath: path,
                source: sourceCode,
                print: { Swift.print($0, terminator: "") }
            ).report(error: error)
        }
    }
}
