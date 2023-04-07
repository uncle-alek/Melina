import Foundation

final class ParserErrorMessageBuilder {
    
    private var errorMessage: String = ""
    private let parserErrorMessenger = ParserErrorMessenger()
    private let filePath: URL
    private let source: String
    private var error: ParserError?
    
    init(
        filePath: String,
        source: String
    ) {
        self.filePath = URL(string: filePath)!
        self.source = source
    }
    
    func setError(_ error: ParserError) -> Self {
        self.error = error
        return self
    }
    
    func fullMessage() -> Self {
        errorMessage += "file:\(filePath.lastPathComponent) "
        errorMessage += "line:\(error!.line) "
        errorMessage += "error: \(parserErrorMessenger.message(for: error!))" + "\n"
        return self
    }
    
    func errorLine() -> Self {
        errorMessage += source.line(error!.index, error!.index) + "\n"
        return self
    }
    
    func marker() -> Self {
        errorMessage += Array(repeating: " ", count: source.offset(error!.index))
        errorMessage +=  "^" + "\n"
        return self
    }
    
    func build() -> String {
        errorMessage
    }
}
