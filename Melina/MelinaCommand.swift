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
        let content = try FileService().content(at: path)
        let tokens = try Lexer(source: content).tokenize()
        let program = try Parser(tokens: tokens).parse()
        let swiftCode = try SwiftCodeGenerator(program: program).generate()
        try swiftCode.testClasses.forEach{ try FileService().write(content: $0.sourceCode, with: $0.name) }
    }
}
