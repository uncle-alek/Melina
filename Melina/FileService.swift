import Foundation

enum FileServiceError: Error {
    case fileIsNotExist
    case contentIsNotAvailable
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
            throw FileServiceError.fileIsNotExist
        }
        guard let data = fileManager.contents(atPath: path) else {
            throw FileServiceError.contentIsNotAvailable
        }
        return String(decoding: data, as: UTF8.self)
    }
}
