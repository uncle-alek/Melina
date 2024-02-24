import XCTest

final class SwiftTeCodeGeneratorTests: BaseSwiftTeCodeGeneratorTests {

    func test_swift_tecode_generation() {
        assert(
            source:
                """
                suite "Home Screen":
                    scenario "Open Home Screen":
                        arguments:
                            "clearState" : "true"
                        end
                        tap button[name: "Ok"]
                    end
                end
                """,
            fileName: "HomeScreenTeCode.json",
            code:
                SwiftTeCode(
                    commands: [
                        SwiftTeCode.Command(mnemonic: .suiteBegin, operands: ["Home Screen"]),
                        SwiftTeCode.Command(mnemonic: .scenarioBegin, operands: ["Open Home Screen"]),
                        SwiftTeCode.Command(mnemonic: .application, operands: []),
                        SwiftTeCode.Command(mnemonic: .launchArgument, operands: ["RUNNING_UI_TESTS"]),
                        SwiftTeCode.Command(mnemonic: .launchEnvironment, operands: ["clearState", "true"]),
                        SwiftTeCode.Command(mnemonic: .launch, operands: []),
                        SwiftTeCode.Command(mnemonic: .button, operands: ["Ok"]),
                        SwiftTeCode.Command(mnemonic: .exists, operands: []),
                        SwiftTeCode.Command(mnemonic: .jumpIfTrue, operands: ["2"]),
                        SwiftTeCode.Command(mnemonic: .waitForExistence, operands: ["5"]),
                        SwiftTeCode.Command(mnemonic: .assertBool, operands: ["true"]),
                        SwiftTeCode.Command(mnemonic: .tap, operands: []),
                        SwiftTeCode.Command(mnemonic: .terminate, operands: []),
                        SwiftTeCode.Command(mnemonic: .scenarioEnd, operands: ["Open Home Screen"]),
                        SwiftTeCode.Command(mnemonic: .suiteEnd, operands: ["Home Screen"])
                    ]
                )
            )
        }
}
