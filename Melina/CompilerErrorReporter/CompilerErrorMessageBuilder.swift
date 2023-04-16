import Foundation

protocol ErrorMessenger {
    associatedtype E
    func message(for error: E) -> String
}

final class CompilerErrorMessageBuilder<E, M: ErrorMessenger> where E == M.E {
    
    private var errorMessage: String = ""
    private let errorMessenger: M
    private let filePath: URL
    private let source: MelinaString
    
    init(
        filePath: String,
        source: String,
        errorMessenger: M
    ) {
        self.filePath = URL(string: filePath)!
        self.source = MelinaString.create(with: source)
        self.errorMessenger = errorMessenger
    }
    
    func fullMessage(line: Int, error: E)  -> Self {
        errorMessage += "file: \(filePath.lastPathComponent) "
        errorMessage += "line: \(line) "
        errorMessage += "error: \(errorMessenger.message(for: error))" + "\n"
        return self
    }
    
    func errorLine(index: String.Index) -> Self {
        errorMessage += source.textLine(index, index) + "\n"
        return self
    }
    
    func marker(index: String.Index) -> Self {
        errorMessage += Array(repeating: " ", count: source.offset(index))
        errorMessage +=  "^" + "\n"
        return self
    }
    
    func build() -> String {
        errorMessage
    }
}
