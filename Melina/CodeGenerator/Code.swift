import Foundation

struct File: Equatable {
    let fileExtension: String
    let content: String

    init(
        fileExtension: String,
        content: String
    ) {
        self.fileExtension = fileExtension
        self.content = content
    }
}
