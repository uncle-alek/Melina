import XCTest

final class SwiftCodeGeneratorTests: BaseSwiftCodeGeneratorTest {

    func test_name_generation() throws {
        try assertName(
            suiteName: "Home Screen",
            expect: "HomeScreenUITests.swift"
        )
    }

    func test_name_generation_with_lower_cased_suite_name() throws {
        try assertName(
            suiteName: "home screen",
            expect: "HomeScreenUITests.swift"
        )
    }

    func test_name_generation_with_multiple_spaces_in_suite_name() throws {
        try assertName(
            suiteName: "Home       Screen",
            expect: "HomeScreenUITests.swift"
        )
    }

    func test_imports_generation() throws {
        try assertImports(
            expect: ["import XCTest"]
        )
    }

    func test_class_definition() throws {
        try assertClassDefinition(
            suiteName: "Home Screen",
            expect: "final class HomeScreenUITests: XCTestCase"
        )
    }

    func test_class_definition_with_lower_cased_suite_name() throws {
        try assertClassDefinition(
            suiteName: "home screen",
            expect: "final class HomeScreenUITests: XCTestCase"
        )
    }

    func test_class_definition_with_multiple_spaces_in_suite_name() throws {
        try assertClassDefinition(
            suiteName: "Home     Screen",
            expect: "final class HomeScreenUITests: XCTestCase"
        )
    }

    func test_method_definition() throws {
        try assertMethodDefinition(
            scenarioName: "Open Home Screen",
            expect: "func testOpenHomeScreen()"
        )
    }

    func test_method_definition_with_lower_cased_suite_name() throws {
        try assertMethodDefinition(
            scenarioName: "open home screen",
            expect: "func testOpenHomeScreen()"
        )
    }

    func test_method_definition_with_multiple_spaces_in_suite_name() throws {
        try assertMethodDefinition(
            scenarioName: "Open      Home    Screen",
            expect: "func testOpenHomeScreen()"
        )
    }

    func test_private_method_launch_app() throws {
        try assertPrivateMethodLaunchApp(
            expect: 
"""
private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
continueAfterFailure = false
let app = XCUIApplication()
app.launchEnvironment = launchEnvironment
app.launch()
return app
}
"""
        )
    }

    func test_call_launch_app_with_no_arguments() throws {
        try assertCallLaunchApp(
            arguments: [],
            expect:
"""
let app = launchApp([:])
"""
        )
    }

    func test_call_launch_app_with_arguments() throws {
        try assertCallLaunchApp(
            arguments: [
                "\"clear_state\": \"true\"",
                "\"use_mock_api\": \"false\""
            ],
            expect:
"""
let app = launchApp([
"clear_state":"true",
"use_mock_api":"false",
])
"""
        )
    }

    func test_call_xctest_api_with_tap_button() throws {
        try assertCallXCtestApi(
            step: "tap button[name:\"Cancel\"]",
            expect: [
                "let button_1 = app.buttons[\"Cancel\"].firstMatch",
                "waitForExistenceIfNeeded(button_1)",
                "button_1.tap()"
            ]
        )
    }

    func test_private_method_wait_for_existence_if_needed() throws {
        try assertPrivateMethodWaitForExistenceIfNeeded(
            expect:
"""
private func waitForExistenceIfNeeded(_ element: XCUIElement) {
if !element.exists {
XCTAssertTrue(element.waitForExistence(timeout: 5))
}
}
"""
        )
    }

    func test_full_test_method() throws {
        try assertFullTestMethod(
            scenarioName: "Login user",
            arguments: [
                "\"clear_state\": \"true\"",
                "\"use_mock_api\": \"false\""
            ],
            steps: [
                "tap button[name: \"Log in\"]",
                "tap button[name: \"Ok\"]"
            ],
            expect:
"""
func testLoginUser() {
let app = launchApp([
"clear_state":"true",
"use_mock_api":"false",
])
let button_1 = app.buttons["Log in"].firstMatch
waitForExistenceIfNeeded(button_1)
button_1.tap()
let button_2 = app.buttons["Ok"].firstMatch
waitForExistenceIfNeeded(button_2)
button_2.tap()
}
"""
        )
    }

    func test_full_class() throws {
        try assertFullClass(
            suiteName: "Home page",
            scenarioName: "Login user",
            arguments: [
                "\"clear_state\": \"true\"",
            ],
            steps: [
                "tap button[name: \"Log in\"]",
            ],
            expect:
"""
final class HomePageUITests: XCTestCase {

    func testLoginUser() {
        let app = launchApp([
            "clear_state":"true",
        ])
        let button_1 = app.buttons["Log in"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }

    private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = launchEnvironment
        app.launch()
        return app
    }
    private func waitForExistenceIfNeeded(_ element: XCUIElement) {
        if !element.exists {
            XCTAssertTrue(element.waitForExistence(timeout: 5))
        }
    }
}
"""
        )
    }

    func test_full_file() throws {
        try assertFullFile(
            source:
"""
suite "Home screen":
   scenario "Open Home Screen":
       arguments:
           "clear_state" : "true"
       end
       tap button[name: "Ok"]
   end

   scenario "Leave Home Screen":
       arguments:
           "clear_state" : "true"
       end
       tap button[name: "Close"]
   end
end

suite "Login screen":
   scenario "Login successfully":
       arguments:
           "clear_state" : "false"
       end
       tap button[name: "Log in"]
   end
end
""",
            expect:
                Code(
                    files: [
                        File(
                            name: "HomeScreenUITests.swift",
                            content:
"""
import XCTest

final class HomeScreenUITests: XCTestCase {

    func testOpenHomeScreen() {
        let app = launchApp([
            "clear_state":"true",
        ])
        let button_1 = app.buttons["Ok"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }

    func testLeaveHomeScreen() {
        let app = launchApp([
            "clear_state":"true",
        ])
        let button_1 = app.buttons["Close"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }

    private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = launchEnvironment
        app.launch()
        return app
    }
    private func waitForExistenceIfNeeded(_ element: XCUIElement) {
        if !element.exists {
            XCTAssertTrue(element.waitForExistence(timeout: 5))
        }
    }
}

"""
                        ),
                        File(
                            name: "LoginScreenUITests.swift",
                            content:
"""
import XCTest

final class LoginScreenUITests: XCTestCase {

    func testLoginSuccessfully() {
        let app = launchApp([
            "clear_state":"false",
        ])
        let button_1 = app.buttons["Log in"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }

    private func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = launchEnvironment
        app.launch()
        return app
    }
    private func waitForExistenceIfNeeded(_ element: XCUIElement) {
        if !element.exists {
            XCTAssertTrue(element.waitForExistence(timeout: 5))
        }
    }
}

"""
                        )
                    ]
                )
        )
    }
}
