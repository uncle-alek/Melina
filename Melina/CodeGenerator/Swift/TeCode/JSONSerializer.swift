import Foundation

final class JSONSerializer {

    static func serialize(_ code: SwiftTeCode) -> String {
        var result = "[" + "\n"
        for command in code.commands {
            let data = try! JSONEncoder().encode(command)
            let stringData = String(data: data, encoding: .utf8)!
            result += stringData + "," + "\n"
        }
        result += "]"
        return result
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

extension SwiftTeCode.Command: Codable {

    enum CodingKeys: String, CodingKey {
        case operands
        case mnemonic
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mnemonic, forKey: .mnemonic)
        try container.encode(operands, forKey: .operands)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mnemonicString = try container.decode(String.self, forKey: .mnemonic)
        mnemonic = SwiftTeCode.Mnemonic(rawValue: mnemonicString)!
        operands = try container.decode([String].self, forKey: .operands)
    }
}

extension SwiftTeCode.Mnemonic: Codable {}
