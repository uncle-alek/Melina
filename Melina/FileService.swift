import Foundation

struct FileServiceError: Error, LocalizedError {
    
    let type: `Type`
    let filePath: String
    
    enum `Type` {
        case fileIsNotExist
        case contentIsNotAvailable
        case failToCreateFile
    }
    
    var errorDescription: String? {
        switch type {
        case .fileIsNotExist: return "file does not exist at path: \(filePath)"
        case .contentIsNotAvailable: return "file's content is not available at path: \(filePath)"
        case .failToCreateFile: return "failed to crate file at path: \(filePath)"
        }
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
    ) throws -> String {
        guard fileManager.fileExists(atPath: path) else {
            throw FileServiceError(type: .fileIsNotExist, filePath: path)
        }
        guard let data = fileManager.contents(atPath: path) else {
            throw FileServiceError(type: .contentIsNotAvailable, filePath: path)
        }
        return String(decoding: data, as: UTF8.self)
    }
    
    func write(
        content: String,
        with fileName: String
    ) throws {
        let filePath = fileManager.currentDirectoryPath + "/" + fileName
        let isFileCreated = fileManager.createFile(atPath: filePath, contents: Data(content.utf8))
        if !isFileCreated { throw FileServiceError(type: .failToCreateFile, filePath: filePath) }
    }
}
