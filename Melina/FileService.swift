import Foundation

struct FileServiceError: Error {
    
    let type: `Type`
    let filePath: String
    
    enum `Type` {
        case fileIsNotExist
        case contentIsNotAvailable
        case failToCreateFile
    }
}

final class FileService {
    
    private let fileManager: FileManager
    
    init(
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
    }
    
    func content(
        at path: String
    ) -> Result<String, [Error]> {
        guard fileManager.fileExists(atPath: path) else {
            return .failure([FileServiceError(type: .fileIsNotExist, filePath: path)])
        }
        guard let data = fileManager.contents(atPath: path) else {
            return .failure([FileServiceError(type: .contentIsNotAvailable, filePath: path)])
        }
        return .success(String(decoding: data, as: UTF8.self))
    }
    
    func write(
        code: Code
    ) -> Result<Void, [Error]> {
        let errors = code.testClasses.compactMap { write(content: $0.generatedCode, with: $0.name) }
        if errors.isEmpty {
            return .success(())
        } else {
            return .failure(errors)
        }
    }
}

private extension FileService {
    
    func write(
        content: String,
        with fileName: String
    ) -> Error? {
        let filePath = fileManager.currentDirectoryPath + "/" + fileName
        let isFileCreated = fileManager.createFile(atPath: filePath, contents: Data(content.utf8))
        if !isFileCreated { return FileServiceError(type: .failToCreateFile, filePath: filePath) }
        return nil
    }
}
