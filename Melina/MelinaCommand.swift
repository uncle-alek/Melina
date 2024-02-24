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
        let tecode = try Compiler(source: sourceCode, filePath: path).compileSwiftTeCode()
        if let output {
            try tecode.files.forEach {
                try FileService().writeToFile(content: $0.content, at: output)
            }
        } else {
            try tecode.files.forEach {
                try FileService().writeToJsonFile(content: $0.content, at: path)
            }
        }
    }
}
