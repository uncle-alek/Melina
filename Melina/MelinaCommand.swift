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
        let serializedTecode = JSONSerializer.serialize(tecode)
        if let output {
            try FileService().writeToFile(content: serializedTecode, at: output)
        } else {
            try FileService().writeToJsonFile(content: serializedTecode, at: path)
        }
    }
}
