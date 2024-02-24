import Foundation

struct Code: Equatable {
    let files: [File]
}

struct File: Equatable {
    let name: String
    let content: String

    init(
        name: String,
        content: String
    ) {
        self.name = name
        self.content = content
    }
}
