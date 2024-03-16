struct SwiftTeCode: Equatable {
    let commands: [Command]

    struct Command: Equatable {
        let mnemonic: Mnemonic
        let operands: [String]

        static func command(_ mnemonic: Mnemonic, with operands: [String] = []) -> Command {
            return Command(mnemonic: mnemonic, operands: operands)
        }
    }

    enum Mnemonic: String {
        // application
        case application = "application"
        case launch = "launch"
        case terminate = "terminate"
        case launchEnvironment = "launchEnvironment"

        // elements
        case button = "button"
        case staticText = "staticText"
        case textField = "textField"
        case otherElement = "otherElement"

        // elements properties
        case exists = "exists"
        case isSelected = "isSelected"
        case value = "value"

        // wait for element
        case waitForExistence = "waitForExistence"
        case waitForDisappear = "waitForDisappear"

        // actions
        case tap = "tap"
        case typeText = "typeText"

        // asserts
        case assertTrue = "assertTrue"
        case assertFalse = "assertFalse"
        case assertEqual = "assertEqual"

        // others
        case print = "print"

        // placeholders
        case subscenarioCall
    }
}
