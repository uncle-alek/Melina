import Foundation
import XCTest

final class ParserErrorTests: BaseParserTests {

    func test_definition_error() {
        assert(
            source: "",
            throws: TestParserError(
                expected: .definition,
                line: 0,
                offset: 0
            )
        )

        assert(
            source:
                """
                "HomeScreen":
                    scenario "Open Home Screen":
                        tap button "Button_1"
                    end
                end
                """,
            throws: TestParserError(
                expected: .definition,
                line: 0,
                offset: 0
            )
        )
    }

    func test_step_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                    end
                end
                """,
            throws: TestParserError(
                expected: .step,
                line: 2,
                offset: 51
            )
        )

        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        button "Button_1"
                    end
                end
                """,
            throws: TestParserError(
                expected: .step,
                line: 2,
                offset: 51
            )
        )
    }

    func test_subscenario_name_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        subscenario
                    end
                end
                """,
            throws: TestParserError(
                expected: .subscenarioName,
                line: 4,
                offset: 77
            )
        )
    }

    func test_suite_name_error() {
        assert(
            source:
                """
                suite :
                    scenario "Open Home Screen":
                        tap button "Button_1"
                    end
                end
                """,
            throws:  TestParserError(
                expected: .suiteName,
                line: 1,
                offset: 6
            )
        )
    }

    func test_scenario_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                end
                """,
            throws: TestParserError(
                expected: .scenario,
                line: 2,
                offset: 20
            )
        )
        assert(
            source:
                """
                suite "HomeScreen":
                    "Open Home Screen":
                        tap button "Button_1"
                    end
                end
                """,
            throws: TestParserError(
                expected: .scenario,
                line: 2,
                offset: 24
            )
        )
    }

    func test_scenario_name() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario :
                        tap button "Button_1"
                    end
                end
                """,
            throws: TestParserError(
                expected: .scenarioName,
                line: 2,
                offset: 33
            )
        )
    }

    func test_argument_key_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                             to "true"
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .argumentKey,
                line: 4,
                offset: 85
            )
        )
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .argumentKey,
                line: 4,
                offset: 80
            )
        )
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                            "clear" to "true"
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .argumentKey,
                line: 5,
                offset: 110
            )
        )
    }

    func test_argument_to_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                            "clear" "true"
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .argumentTo,
                line: 4,
                offset: 92
            )
        )
    }

    func test_argument_value_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                            "clear" to
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .argumentValue,
                line: 5,
                offset: 103
            )
        )
    }

    func test_element_type_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap "Button_1"
                    end
                end
                """,
            throws: TestParserError(
                expected: .elementType,
                line: 3,
                offset: 65
            )
        )
    }

    func test_element_name_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button
                    end
                end
                """,
            throws: TestParserError(
                expected: .elementName,
                line: 4,
                offset: 76
            )
        )
    }

    func test_colon_error() {
        assert(
            source:
                """
                suite "HomeScreen"
                    scenario "Open Home Screen":
                        arguments:
                            "clear" to "true"
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .colon,
                line: 2,
                offset: 23
            )
        )

        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen"
                        arguments:
                            "clear" to "true"
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .colon,
                line: 3,
                offset: 60
            )
        )

        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments
                            "clear" to "true"
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: TestParserError(
                expected: .colon,
                line: 4,
                offset: 83
            )
        )

        assert(
            source:
                """
                subscenario "HomeScreen"
                    verify view "homeScreenIdentifier"
                end
                """,
            throws: TestParserError(
                expected: .colon,
                line: 2,
                offset: 29
            )
        )
    }

    func test_end() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                            "clear" to "true"
                        end
                        verify view "homeScreenIdentifier"
                    end
                """,
            throws: TestParserError(
                expected: .end,
                line: 7,
                offset: 161
            )
        )

        assert(
            source:
                """
                subscenario "HomeScreen":
                    verify view "homeScreenIdentifier"
                """,
            throws: TestParserError(
                expected: .end,
                line: 2,
                offset: 42
            )
        )
    }
}
