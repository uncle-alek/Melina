final class SemanticAnalyzerFileServiceStub: SemanticAnalyzerFileService {

    var exists: Bool = true
    func fileExists(at Path: String) -> Bool {
        return self.exists
    }

    var content: String? = "{}"
    func loadContent(from path: String) -> String? {
        return self.content
    }
}
