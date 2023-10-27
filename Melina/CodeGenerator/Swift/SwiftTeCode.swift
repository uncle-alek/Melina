struct SwiftTeCode: Equatable {
    let commands: [Command]

    struct Command: Equatable {
        let mnemonic: Mnemonic
        let operands: [String]
    }

    enum Mnemonic: String {
        // application
        case application = "application"
        case launch = "launch"
        case terminate = "terminate"
        case launchEnvironment = "launchEnvironment"
        case launchArgument = "launchArgument"

        // elements
        case button = "button"
        case staticText = "staticText"
        case textField = "textField"
        case scrollView = "scrollView"
        case view = "view"

        // elements properties
        case isHittable = "isHittable"
        case exists = "exists"
        case label = "label"
        case isSelected = "isSelected"
        case waitForExistence = "waitForExistence"

        // actions
        case tap = "tap"
        case typeText = "typeText"
        case swipeUp = "swipeUp"
        case swipeDown = "swipeDown"
        case swipeLeft = "swipeLeft"
        case swipeRight = "swipeRight"

        // asserts
        case assertBool = "assertBool"
        case assertString = "assertString"

        // control transfer
        case jumpIfTrue = "jumpIfTrue"
        case jump = "jump"

        // other
        case suiteBegin = "suiteBegin"
        case suiteEnd = "suiteEnd"
        case scenarioBegin = "scenarioBegin"
        case scenarioEnd = "scenarioEnd"
        case print = "print"
    }
}
