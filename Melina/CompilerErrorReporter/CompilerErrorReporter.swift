import Foundation

final class CompilerErrorReporter {
    
    private var pemb: () -> CompilerErrorMessageBuilder<ParserError, ParserErrorMessenger>
    private var lemb: () -> CompilerErrorMessageBuilder<LexerError, LexerErrorMessenger>
    private var saemb: () -> CompilerErrorMessageBuilder<SemanticAnalyzerError, SemanticAnalyzerErrorMessenger>
    private let print: (_ items: String) -> Void
    
    init(
        filePath: String,
        source: String,
        print: @escaping (_ items: String) -> Void = { Swift.print($0, terminator: "") }
    ) {
        self.print = print
        self.pemb = { CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: ParserErrorMessenger()) }
        self.lemb = { CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: LexerErrorMessenger()) }
        self.saemb = { CompilerErrorMessageBuilder(filePath: filePath, source: source, errorMessenger: SemanticAnalyzerErrorMessenger()) }
    }
    
    func report(errors: [Error]) {
        errors.forEach(report(error:))
    }
}

private extension CompilerErrorReporter {
    
    func report(error: Error) {
        switch error {
        case is LexerError: report(lexerError: error as! LexerError)
        case is ParserError: report(parserError: error as! ParserError)
        case is SemanticAnalyzerError: report(error as! SemanticAnalyzerError)
        default: fatalError("Unknown error")
        }
    }
    
    func report(lexerError: LexerError) {
        let message = lemb()
            .fullMessage(line: lexerError.line, error: lexerError)
            .errorLine(index: lexerError.index)
            .marker(index: lexerError.index)
            .build()
        print(message)
    }
    
    func report(parserError: ParserError) {
        let message = pemb()
            .fullMessage(line: parserError.line, error: parserError)
            .errorLine(index: parserError.index)
            .marker(index: parserError.index)
            .build()
        print(message)
    }
    
    func report(_ error: SemanticAnalyzerError) {
        var line: Int!
        var lineIndex: String.Index!
        var markerIndex: String.Index!
        switch error.type {
        case .incompatibleElement:
            line = error.action!.line
            lineIndex = error.action!.startIndex
            markerIndex = error.action!.startIndex
        case .suiteNameCollision:
            line = error.suite!.line
            lineIndex = error.suite!.startIndex
            markerIndex = error.suite!.startIndex
        case .scenarioNameCollision:
            line = error.scenario!.line
            lineIndex = error.scenario!.startIndex
            markerIndex = error.scenario!.startIndex
        case .missingCondition:
            line = error.action!.line
            lineIndex = error.action!.startIndex
            markerIndex = error.action!.startIndex
        case .incompatibleCondition:
            line = error.action!.line
            lineIndex = error.action!.startIndex
            markerIndex = error.action!.startIndex
        case .subscenarioRecursion:
            line = error.subscenarioCall!.line
            lineIndex = error.subscenarioCall!.startIndex
            markerIndex = error.subscenarioCall!.startIndex
        case .subscenarioNameCollision:
            line = error.subscenarioDefinition!.line
            lineIndex = error.subscenarioDefinition!.startIndex
            markerIndex = error.subscenarioDefinition!.startIndex
        case .subscenarioDefinitionNotFound:
            line = error.subscenarioCall!.line
            lineIndex = error.subscenarioCall!.startIndex
            markerIndex = error.subscenarioCall!.startIndex
        case .redundantCondition:
            line = error.action!.line
            lineIndex = error.action!.startIndex
            markerIndex = error.action!.startIndex
        case .jsonNameCollision:
            line = error.jsonDefinition!.line
            lineIndex = error.jsonDefinition!.startIndex
            markerIndex = error.jsonDefinition!.startIndex
        case .jsonDefinitionNotFound:
            line = error.jsonReference!.line
            lineIndex = error.jsonReference!.startIndex
            markerIndex = error.jsonReference!.startIndex
        case .jsonFileNotFound:
            line = error.jsonFilePath!.line
            lineIndex = error.jsonFilePath!.startIndex
            markerIndex = error.jsonFilePath!.startIndex
        case .jsonFileContentHasIncorrectFormat:
            line = error.jsonFilePath!.line
            lineIndex = error.jsonFilePath!.startIndex
            markerIndex = error.jsonFilePath!.startIndex
        case .jsonFileAbsolutePath:
            line = error.jsonFilePath!.line
            lineIndex = error.jsonFilePath!.startIndex
            markerIndex = error.jsonFilePath!.startIndex
        }
        let message = saemb()
            .fullMessage(line: line, error: error)
            .errorLine(index: lineIndex)
            .marker(index: markerIndex)
            .build()
        print(message)
    }
}
