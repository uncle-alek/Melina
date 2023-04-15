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
            try FileService().content(at: path)
                .flatMap { Lexer(source: $0).tokenize() }
                .flatMap { Parser(tokens: $0).parse() }
                .flatMap { SemanticAnalyzer(program: $0).analyze() }
                .flatMap { SwiftCodeGenerator(program: $0).generate() }
                .flatMap { FileService().write(code: $0) }
                .get()
        } catch let errors as [Error] {
            ErrorReporter(filePath: path, source: sourceCode).report(errors: errors)
        }
    }
}
