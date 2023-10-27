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
        let tecode = try Compiler(source: sourceCode, filePath: path).compileSwiftTeCode()
        let serializedTecode = JSONSerializer.serialize(tecode)
        try FileService().write(content: serializedTecode, at: path)
    }
}
