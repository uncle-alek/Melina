final class JsonTable {

    private var table: [String:String] = [:]

    func put(_ name: String, json: String) {
        table[name] = json
    }

    func get(_ name: String) -> String? {
        table[name]
    }
}
