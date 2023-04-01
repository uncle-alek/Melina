import XCTest

final class SwiftCodeGeneratorTests: XCTestCase {
    
    func test_swift() {
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
                                        let app = launchApp()
                                        app.launchEnvironment = [
                                            "clearState" : "true",
                                        ]
                                        app.staticTexts["homeScreenIdentifier"].waitForExistance(timeout: 3)
                                    }
                                
                                    private func launchApp() {
                                        continueAfterFailure = false
                                        let app: XCUIApplication = XCUIApplication()
                                        return app
                                    }
                                }
                                
                                """
                            )
                    ]
                )
        )
    }
}
