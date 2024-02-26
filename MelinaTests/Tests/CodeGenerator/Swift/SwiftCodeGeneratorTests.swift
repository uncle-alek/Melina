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

    func test_method_definition_for_scenario() throws {
        try assertMethodDefinition(
            scenarioName: "Open Home Screen",
            expect: "func testOpenHomeScreen()"
        )
    }

    func test_method_definition_for_scenario_with_lower_cased_suite_name() throws {
        try assertMethodDefinition(
            scenarioName: "open home screen",
            expect: "func testOpenHomeScreen()"
        )
    }

    func test_method_definition_for_scenario_with_multiple_spaces_in_suite_name() throws {
        try assertMethodDefinition(
            scenarioName: "Open      Home    Screen",
            expect: "func testOpenHomeScreen()"
        )
    }

    func test_private_method_launch_app() throws {
        try assertPrivateMethodLaunchApp(
            expect:
"""
fileprivate extension XCTestCase {
func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
continueAfterFailure = false
let app = XCUIApplication()
app.launchEnvironment = launchEnvironment
app.launch()
return app
}
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
                "\"clear_state\" to \"true\"",
                "\"use_mock_api\" to \"false\""
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
            step: "tap button \"Cancel\"",
            expect: [
                "let button_1 = app.buttons[\"Cancel\"].firstMatch",
                "waitForExistenceIfNeeded(button_1)",
                "button_1.tap()"
            ]
        )
    }

    func test_call_xctest_api_with_verify_view_is_exist() throws {
        try assertCallXCtestApi(
            step: "verify view \"View_1\" is exist",
            expect: [
                "let view_1 = app.otherElements[\"View_1\"].firstMatch",
                "waitForExistenceIfNeeded(view_1)"
            ]
        )
    }

    func test_call_xctest_api_with_verify_view_is_not_exist() throws {
        try assertCallXCtestApi(
            step: "verify view \"View_1\" is not exist",
            expect: [
                "let view_1 = app.otherElements[\"View_1\"].firstMatch",
                "XCTAssertFalse(view_1.exists)"
            ]
        )
    }

    func test_call_xctest_api_with_verify_button_is_selected() throws {
        try assertCallXCtestApi(
            step: "verify button \"Ok\" is selected",
            expect: [
                "let button_1 = app.buttons[\"Ok\"].firstMatch",
                "waitForExistenceIfNeeded(button_1)",
                "XCTAssertTrue(button_1.isSelected)"
            ]
        )
    }

    func test_call_xctest_api_with_verify_button_is_not_selected() throws {
        try assertCallXCtestApi(
            step: "verify button \"Ok\" is not selected",
            expect: [
                "let button_1 = app.buttons[\"Ok\"].firstMatch",
                "waitForExistenceIfNeeded(button_1)",
                "XCTAssertFalse(button_1.isSelected)"
            ]
        )
    }

    func test_call_xctest_api_with_verify_label_contains_value() throws {
        try assertCallXCtestApi(
            step: "verify label \"Label_1\" contains value \"Hello\"",
            expect: [
                "let label_1 = app.staticTexts[\"Label_1\"].firstMatch",
                "waitForExistenceIfNeeded(label_1)",
                "XCTAssertEqual(label_1.value as? String, \"Hello\")"
            ]
        )
    }

    func test_call_xctest_api_with_edit_text_field_with_text() throws {
        try assertCallXCtestApi(
            step: "edit textfield \"Text_1\" with text \"Hello\"",
            expect: [
                "let textField_1 = app.textFields[\"Text_1\"].firstMatch",
                "waitForExistenceIfNeeded(textField_1)",
                "textField_1.tap()",
                "textField_1.typeText(\"Hello\")"
            ]
        )
    }

    func test_call_xctest_api_with_subscenario_call() throws {
        try assertCallXCtestApi(
            step: "subscenario \"Open home screen\"",
            expect: [
                "self.openHomeScreen(app)",
            ]
        )
    }

    func test_private_method_wait_for_existence_if_needed() throws {
        try assertPrivateMethodWaitForExistenceIfNeeded(
            expect:
"""
fileprivate extension XCTestCase {
func waitForExistenceIfNeeded(_ element: XCUIElement) {
if !element.exists {
XCTAssertTrue(element.waitForExistence(timeout: 5))
}
}
}
"""
        )
    }

    func test_full_test_method_for_scenario() throws {
        try assertFullTestMethod(
            scenarioName: "Login user",
            arguments: [
                "\"clear_state\" to \"true\"",
                "\"use_mock_api\" to \"false\""
            ],
            steps: [
                "tap button \"Log in\"",
                "tap button \"Ok\""
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
                "\"clear_state\" to \"true\"",
            ],
            steps: [
                "tap button \"Log in\"",
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

}
"""
        )
    }

    func test_full_file_with_few_suites() throws {
        try assertFullFile(
            source:
"""
suite "Home screen":
   scenario "Open Home Screen":
       arguments:
           "clear_state" to "true"
       end
       tap button "Ok"
   end

   scenario "Leave Home Screen":
       arguments:
           "clear_state" to "true"
       end
       tap button "Close"
   end
end

suite "Login screen":
   scenario "Login successfully":
       arguments:
           "clear_state" to "false"
       end
       tap button "Log in"
   end
end
""",
            expect:
                File(
                    name: "HomeScreenUITests.swift",
                    content:
"""
// Generated by Melina.

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

}

final class LoginScreenUITests: XCTestCase {

    func testLoginSuccessfully() {
        let app = launchApp([
            "clear_state":"false",
        ])
        let button_1 = app.buttons["Log in"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }

}

fileprivate extension XCTestCase {
    func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = launchEnvironment
        app.launch()
        return app
    }
}
fileprivate extension XCTestCase {
    func waitForExistenceIfNeeded(_ element: XCUIElement) {
        if !element.exists {
            XCTAssertTrue(element.waitForExistence(timeout: 5))
        }
    }
}

"""
                )
        )
    }

    func test_method_definition_for_subscenario() throws {
        try assertMethodDefinition(
            subscenarioName: "Open Home Screen",
            expect: "func openHomeScreen(_ app: XCUIApplication)"
        )
    }

    func test_method_definition_for_subscenario_with_single_word_name() throws {
        try assertMethodDefinition(
            subscenarioName: "Open",
            expect: "func open(_ app: XCUIApplication)"
        )
    }

    func test_full_test_method_for_subscenario() throws {
        try assertFullTestMethod(
            subscenarioName: "Open Home Screen",
            steps: [
                "tap button \"Log in\"",
                "tap button \"Ok\""
            ],
            expect:
"""
fileprivate extension XCTestCase {
func openHomeScreen(_ app: XCUIApplication) {
let button_1 = app.buttons["Log in"].firstMatch
waitForExistenceIfNeeded(button_1)
button_1.tap()
let button_2 = app.buttons["Ok"].firstMatch
waitForExistenceIfNeeded(button_2)
button_2.tap()
}
}
"""
        )
    }

    func test_full_file_few_subscenarios() throws {
        try assertFullFile(
            source:
"""
subscenario "Open Home screen":
    tap button "Ok"
end

subscenario "Leave Home Screen":
    tap button "Close"
end
""",
            expect:
                File(
                    name: "OpenHomeScreenUITests.swift",
                    content:
"""
// Generated by Melina.

import XCTest

fileprivate extension XCTestCase {
    func openHomeScreen(_ app: XCUIApplication) {
        let button_1 = app.buttons["Ok"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }
}

fileprivate extension XCTestCase {
    func leaveHomeScreen(_ app: XCUIApplication) {
        let button_1 = app.buttons["Close"].firstMatch
        waitForExistenceIfNeeded(button_1)
        button_1.tap()
    }
}

fileprivate extension XCTestCase {
    func launchApp(_ launchEnvironment: [String : String]) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = launchEnvironment
        app.launch()
        return app
    }
}
fileprivate extension XCTestCase {
    func waitForExistenceIfNeeded(_ element: XCUIElement) {
        if !element.exists {
            XCTAssertTrue(element.waitForExistence(timeout: 5))
        }
    }
}

"""
                )
        )
    }
}
