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
        let code = try Compiler(source: sourceCode, filePath: path).compile()
        try code.testClasses.forEach { try FileService().write(content: $0.generatedCode, with: $0.name) }
    }
}
