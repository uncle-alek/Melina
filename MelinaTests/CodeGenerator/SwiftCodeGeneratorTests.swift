import XCTest

final class SwiftCodeGeneratorTests: XCTestCase {
    
    func test_swift() {
        assert(
            source:
                """
                suite "Home Screen":
                    scenario "Open Home Screen":
                        open "homeScreenIdentifier"
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
                                    }
                                
                                    private func launchApp() {
                                        continueAfterFailure = false
                                        let app: XCUIApplication = XCUIApplication()
                                        app.launchArguments = []
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
