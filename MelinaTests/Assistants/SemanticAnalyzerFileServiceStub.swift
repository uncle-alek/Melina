final class SemanticAnalyzerFileServiceStub: SemanticAnalyzerFileService {

    var exists: Bool = true
    func fileExists(at Path: String) -> Bool {
        return self.exists
    }

    var absolutePath: Bool = false
    func isAbsolutePath(_ path: String) -> Bool {
        return absolutePath
    }

    var content: String? = "{}"
    func loadContent(from path: String) -> String? {
        return self.content
    }
}
