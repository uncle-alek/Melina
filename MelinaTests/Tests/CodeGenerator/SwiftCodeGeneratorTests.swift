import XCTest

final class SwiftCodeGeneratorTests: BaseSwiftCodeGeneratorTests {
    
    func test_swift_code_generation() {
        assert(
            source:
                """
                suite "Home Screen":
                    scenario "Open Home Screen":
                        arguments:
                            "clearState" : "true"
                        end
                        tap button[name: "Button_1"]
                    end
                end
                """,
            produce:
                Code(
                    testClasses: [
                        TestClass(
                            name: "HomeScreenTests.swift",
                            generatedCode: """
                                import XCTest
                                
                                final class HomeScreenTests: XCTestCase {
                                
                                    func testOpenHomeScreen() {
                                        let app = launchApp([
                                            "clearState" : "true",
                                        ])
                                        app.buttons["Button_1"].firstMatch.tap()
                                    }
                                
                                    private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
                                        continueAfterFailure = false
                                        let app = XCUIApplication()
                                        app.launchEnvironment = launchEnvironment
                                        app.launch()
                                        return app
                                    }
                                }
                                
                                private extension XCUIElement {
                                    func verifyExistence(timeout: TimeInterval) {
                                        XCTAssertTrue(self.waitForExistence(timeout: timeout))
                                    }
                                }
                                
                                """
                            )
                    ]
                )
        )
    }
}
