import Foundation

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
