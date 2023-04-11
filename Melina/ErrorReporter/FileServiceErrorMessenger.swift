struct FileServiceErrorMessenger: ErrorMessenger {
 
    func message(for error: FileServiceError) -> String {
        switch error.type {
        case .fileIsNotExist: return "file does not exist at path: \(error.filePath)"
        case .contentIsNotAvailable: return "file's content is not available at path: \(error.filePath)"
        case .failToCreateFile: return "failed to crate file at path: \(error.filePath)"
        }
    }
}
