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
                        verify "homeScreenIdentifier" text
                    end
                end
                """,
            produce:
                Code(
                    testClasses: [
                        TestClass(
                            "HomeScreenTests.swift",
                                """
                                import XCTest
                                
                                final class HomeScreenTests: XCTestCase {
                                
                                    func testOpenHomeScreen() {
                                        let app = launchApp([
                                            "clearState" : "true",
                                        ])
                                        app.staticTexts["homeScreenIdentifier"].firstMatch.verifyExistence(timeout: 3)
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
