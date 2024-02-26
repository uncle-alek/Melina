import ArgumentParser

struct Melina: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "melina",
        abstract: "Code generator for UITests."
    )

    enum Language: String, ExpressibleByArgument, CaseIterable {
      case swift = "swift"
      case swiftTeCode = "swiftTeCode"

      static var allCases: [Language] {
        return [.swift, .swiftTeCode]
      }
    }

    @Option(
        name: [.customShort("p"), .customLong("path")],
        help: "The path to the test specification."
    )
    var path: String

    @Option(
        name: [.customShort("l"), .customLong("lang")],
        help: "The generated language."
    )
    var language: Language

    @Option(
        name: [.customShort("o"), .customLong("output")],
        help: "The output file path."
    )
    var output: String?

    mutating func run() throws {
        let sourceCode = try FileService().content(at: path)
        let file = switch language {
        case .swift       : try Compiler(source: sourceCode, filePath: path).compileSwiftCode()
        case .swiftTeCode : try Compiler(source: sourceCode, filePath: path).compileSwiftTeCode()
        }
        let filePath = if let output {
            try FileService().writeToFile(content: file.content, at: output)
        } else {
            try FileService().writeToFile(fileExtension: file.fileExtension, content: file.content, at: path)
        }
        print("The file has been generated and is ready for use.\n" +
              "You can find the file at path: \(filePath).\n")
    }
}
