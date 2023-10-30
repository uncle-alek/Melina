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
        case .failToCreateFile: return "failed to create file at path: \(filePath)"
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
    
    func writeToJsonFile(
        content: String,
        at path: String
    ) throws {
        let filePath = URL(string: path)!
        let fileNameWithSuffix = filePath.deletingPathExtension().lastPathComponent + "Generated.tecode"
        let newFilePath = filePath
            .deletingLastPathComponent()
            .appendingPathComponent(fileNameWithSuffix)
            .appendingPathExtension("json")
            .absoluteString
        let isFileCreated = fileManager.createFile(atPath: newFilePath, contents: Data(content.utf8))
        if !isFileCreated { throw FileServiceError(type: .failToCreateFile, filePath: newFilePath) }
    }

    func writeToFile(
        content: String,
        at path: String
    ) throws {
        let isFileCreated = fileManager.createFile(atPath: path, contents: Data(content.utf8))
        if !isFileCreated { throw FileServiceError(type: .failToCreateFile, filePath: path) }
    }
}
