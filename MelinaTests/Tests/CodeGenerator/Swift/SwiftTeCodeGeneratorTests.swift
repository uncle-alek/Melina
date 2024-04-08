import XCTest

final class SwiftTeCodeGeneratorTests: BaseSwiftTeCodeGeneratorTests {

    func test_swift_tecode_generation() {
        assert(
            source:
                """
                suite "Home Screen":
                    scenario "Open Home Screen":
                        arguments:
                            "clearState" to "true"
                        end
                        tap button "Ok"
                    end
                end
                """,
            fileExtension: "json",
            code:
                SwiftTeCode(
                    commands: [
                        SwiftTeCode.Command(mnemonic: .application, operands: []),
                        SwiftTeCode.Command(mnemonic: .launchEnvironment, operands: ["RUNNING_UI_TESTS", "true"]),
                        SwiftTeCode.Command(mnemonic: .launchEnvironment, operands: ["clearState", "true"]),
                        SwiftTeCode.Command(mnemonic: .launch, operands: []),
                        SwiftTeCode.Command(mnemonic: .button, operands: ["Ok"]),
                        SwiftTeCode.Command(mnemonic: .waitForExistence, operands: ["5"]),
                        SwiftTeCode.Command(mnemonic: .tap, operands: []),
                        SwiftTeCode.Command(mnemonic: .terminate, operands: []),
                    ]
                )
            )
        }
}
