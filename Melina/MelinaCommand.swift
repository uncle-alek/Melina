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

    @Option(
        name: [.customShort("o"), .customLong("output")],
        help: "The output file path."
    )
    var output: String?

    mutating func run() throws {
        let sourceCode = try FileService().content(at: path)
        let file = try Compiler(source: sourceCode, filePath: path).compileSwiftTeCode()
        if let output {
            try FileService().writeToFile(content: file.content, at: output)
        } else {
            try FileService().writeToJsonFile(content: file.content, at: path)
        }
    }
}
