import Foundation
import XCTest

final class ParserErrorTests: BaseParserTests {

    func test_definition_error() {
        assert(
            source: "",
            throws: .definition
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
            throws: .definition
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
            throws: .step
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
            throws: .step
        )
    }

    func test_subscenario_call_name_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        subscenario
                    end
                end
                """,
            throws: .subscenarioCallName
        )
    }

    func test_subscenario_definition_name_error() {
        assert(
            source:
                """
                subscenario:
                    tap button "Ok"
                end
                """,
            throws: .subscenarioDefinitionName
        )
    }

    func test_json_definition_name_error() {
        assert(
            source:
                """
                json:
                    file "./Mock.json"
                end
                """,
            throws: .jsonDefinitionName
        )
    }

    func test_json_file_error() {
        assert(
            source:
                """
                json "Mock":
                    "./Mock.json"
                end
                """,
            throws: .jsonFile
        )
    }

    func test_json_path_error() {
        assert(
            source:
                """
                json "Mock":
                    file
                end
                """,
            throws: .jsonFilePath
        )
    }

    func test_json_reference_name_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        arguments:
                            "endpoint" to json
                        end
                        verify view "homeScreenIdentifier"
                    end
                end
                """,
            throws: .jsonReferenceName
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
            throws: .suiteName
        )
    }

    func test_scenario_error() {
        assert(
            source:
                """
                suite "HomeScreen":
                end
                """,
            throws: .scenario
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
            throws: .scenario
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
            throws: .scenarioName
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
            throws: .argumentKey
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
            throws: .argumentKey
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
            throws: .argumentKey
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
            throws: .argumentTo
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
            throws: .argumentValue
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
            throws: .elementType
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
            throws: .elementName
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
            throws: .colon
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
            throws: .colon
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
            throws:.colon
        )

        assert(
            source:
                """
                subscenario "HomeScreen"
                    verify view "homeScreenIdentifier"
                end
                """,
            throws: .colon
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
            throws: .end
        )

        assert(
            source:
                """
                subscenario "HomeScreen":
                    verify view "homeScreenIdentifier"
                """,
            throws: .end
        )
    }
}
