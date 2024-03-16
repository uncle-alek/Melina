import Foundation

final class JSONSerializer {

    static func serialize(_ code: SwiftTeCode) -> String {
        var results = "[\n"
        for command in code.commands {
            var commandString = "{"
            commandString += "\"mnemonic\":\"\(command.mnemonic.rawValue)\","
            let operandsString = command.operands.map { "\"\($0)\"" }.joined(separator: ",")
            commandString += "\"operands\":[\(operandsString)]"
            commandString += "},\n"
            results += commandString
        }
        results += "\n]"
        return results
    }

    static func deserialize(_ string: String) -> [SwiftTeCode.Command] {
        var result: [SwiftTeCode.Command] = []
        let jsonData = string.data(using: .utf8)!
        do {
            result = try JSONDecoder().decode([SwiftTeCode.Command].self, from: jsonData)
        } catch {
            print("Failed to decode JSON")
        }
        return result
    }
}

extension SwiftTeCode.Command: Decodable {

    enum CodingKeys: String, CodingKey, CaseIterable {
        case operands
        case mnemonic
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mnemonicString = try container.decode(String.self, forKey: .mnemonic)
        mnemonic = SwiftTeCode.Mnemonic(rawValue: mnemonicString)!
        operands = try container.decode([String].self, forKey: .operands)
    }
}

extension SwiftTeCode.Mnemonic: Codable {}
