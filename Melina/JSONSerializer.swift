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
}

extension SwiftTeCode.Command: Encodable {

    enum CodingKeys: String, CodingKey {
        case operands
        case mnemonic
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mnemonic, forKey: .mnemonic)
        try container.encode(operands, forKey: .operands)
    }
}

extension SwiftTeCode.Mnemonic: Encodable {}
