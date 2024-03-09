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

    func writeToFile(
        fileExtension: String,
        content: String,
        at path: String
    ) throws -> String {
        let filePath = URL(string: path)!
        let fileNameWithSuffix = filePath.deletingPathExtension().lastPathComponent
        let newFilePath = filePath
            .deletingLastPathComponent()
            .appendingPathComponent(fileNameWithSuffix)
            .appendingPathExtension(fileExtension)
            .absoluteString
        let isFileCreated = fileManager.createFile(atPath: newFilePath, contents: Data(content.utf8))
        if !isFileCreated { throw FileServiceError(type: .failToCreateFile, filePath: path) }
        return newFilePath
    }

    func writeToFile(
        content: String,
        at path: String
    ) throws -> String {
        let isFileCreated = fileManager.createFile(atPath: path, contents: Data(content.utf8))
        if !isFileCreated { throw FileServiceError(type: .failToCreateFile, filePath: path) }
        return path
    }
}

extension FileService: SemanticAnalyzerFileService {

    func fileExists(at path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }

    func loadContent(from path: String) -> String? {
        if let content = fileManager.contents(atPath: path) {
            return String(decoding: content, as: UTF8.self)
        }
        return nil
    }
}
