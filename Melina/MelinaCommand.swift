//
//  GenerateCommand.swift
//  Melina
//
//  Created by Aleksey Yakimenko on 18/10/22.
//

import ArgumentParser

struct Melina: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "melina",
        abstract: "Code generator for UITests."
    )

    @Option(
        name: [.customShort("p"), .customLong("path")],
        help: "The path to the test specification."
    )
    var path: String

    mutating func run() throws {
        let content = try FileService().content(at: path)
        print(content)
    }
}
