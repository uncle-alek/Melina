import XCTest

final class SemanticAnalyzerTests: BaseSemanticAnalyzerTests {
    
    func test_suite_name_collision() {
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    tap button "Button_1"
                end
            end
            
            suite "Melina":
                scenario "First scenario":

                    tap button "Button_1"
                end
            end
            
            suite "Melina":
                scenario "First scenario":

                    tap button "Button_1"
                end
            end
            """,
            errors: [
                .suiteNameCollision,
                .suiteNameCollision,
                .suiteNameCollision
            ]
        )
    }
    
    func test_scenario_name_collision() {
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    tap button "Button_1"
                end
                
                scenario "First scenario":

                    tap button "Button_1"
                end
            
                scenario "First scenario":

                    tap button "Button_1"
                end
            end
            """,
            errors: [
                .scenarioNameCollision,
                .scenarioNameCollision,
                .scenarioNameCollision
            ]
        )
    }
    
    func test_incompatible_element_tap() {

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    tap textfield "Hello world!"
                end
            end
            """,
            errors: [
                .incompatibleElement
            ]
        )
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    tap view "View_1"
                end
            end
            """,
            errors: [
                .incompatibleElement
            ]
        )

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    tap label "Label"
                end
            end
            """,
            errors: [
                .incompatibleElement
            ]
        )
    }

    func test_incompatible_action_edit() {

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    edit button "Ok"
                end
            end
            """,
            errors: [
                .incompatibleElement,
                .missingCondition
            ]
        )

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    edit view "View"
                end
            end
            """,
            errors: [
                .incompatibleElement,
                .missingCondition
            ]
        )

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    edit label "Label"
                end
            end
            """,
            errors: [
                .incompatibleElement,
                .missingCondition
            ]
        )
    }

    func test_redundant_condition() {
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    tap button "Ok" contains "Hello"
                end
            end
            """,
            errors: [
                .redundantCondition
            ]
        )
    }

    func test_missing_condition() {

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    edit textfield "Ok"
                end
            end
            """,
            errors: [
                .missingCondition
            ]
        )

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    verify label "Hello"
                end
            end
            """,
            errors: [
                .missingCondition
            ]
        )
    }

    func test_subscenario_analysing_step() {
        assert(
            source:
            """
            subscenario "Login":
                tap view "Ok"
            end
            """,
            errors: [
                .incompatibleElement
            ]
        )
    }

    func test_subscenario_recursion() {

        assert(
            source:
            """
            subscenario "Login":
                tap button "Ok"
                subscenario "Open Home"
                subscenario "Login"
            end
            subscenario "Open Home":
                tap button "Ok"
            end
            """,
            errors: [
                .subscenarioRecursion
            ]
        )
    }

    func test_subscenario_name_collision() {

        assert(
            source:
            """
            subscenario "Login":
                tap button "Ok"
            end
            subscenario "Login":
                tap button "Ok"
            end
            """,
            errors: [
                .subscenarioNameCollision,
                .subscenarioNameCollision
            ]
        )
    }

    func test_subscenario_definition_not_found() {

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":

                    subscenario "Login"
                end
            end
            """,
            errors: [
                .subscenarioDefinitionNotFound
            ]
        )
    }
}

extension SemanticAnalyzerTests {

    func test_suite_and_scenario_with_the_same_name() {

        assertNoError(
            source:
            """
            suite "Melina":
                scenario "Melina":

                    tap button "Ok"
                end
            end
            """
        )
    }

    func test_suite_and_subscenario_with_the_same_name() {

        assertNoError(
            source:
            """
            suite "Melina":
                scenario "Melina":

                    tap button "Ok"
                end
            end
            subscenario "Melina":
                tap button "Ok"
            end
            """
        )
    }
}

extension SemanticAnalyzerTests {

    func test_json_name_collision() {

        assert(
            source:
            """
            json "Login":
                file "./Mock_1.json"
            end
            json "Login":
                file "./Mock_2.json"
            end
            """,
            errors: [
                .jsonNameCollision,
                .jsonNameCollision
            ]
        )
    }

    func test_json_definition_not_found() {

        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "endpoint" to json "Mock"
                    end
                    tap button "Ok"
                end
            end
            """,
            errors: [
                .jsonDefinitionNotFound
            ]
        )
    }
}

extension SemanticAnalyzerTests {

    func test_json_table_entry() {

        assertJsonTable(
            source:
            """
            json "Login endpoint mock":
                file "./Mock.json"
            end
            """,
            fileContent: "[\"Hello\",\"World\"]",
            contains: [
                "Login endpoint mock": "[\"Hello\",\"World\"]"
            ]
        )

        assertJsonTable(
            source:
            """
            json "Login endpoint mock":
                file "./Mock.json"
            end
            """,
            fileContent: "{\"Hello\":\"World\"}",
            contains: [
                "Login endpoint mock": "{\"Hello\":\"World\"}"
            ]
        )
    }

    func test_json_file_content_has_incorrect_format() {

        assertJsonTable(
            source:
            """
            json "Login endpoint mock":
                file "./Mock.json"
            end
            """,
            fileContent: "",
            fileExists: true,
            errors: [
                .jsonFileContentHasIncorrectFormat
            ]
        )

        assertJsonTable(
            source:
            """
            json "Login endpoint mock":
                file "./Mock.json"
            end
            """,
            fileContent: "{hello:world}",
            fileExists: true,
            errors: [
                .jsonFileContentHasIncorrectFormat
            ]
        )
    }

    func test_json_file_not_found() {

        assertJsonTable(
            source:
            """
            json "Login endpoint mock":
                file "./Mock.json"
            end
            """,
            fileContent: "{\"Hello\":\"World\"}",
            fileExists: false,
            errors: [
                .jsonFileNotFound
            ]
        )
    }

    func test_json_file_absolute_path() {

        assertJsonTable(
            source:
            """
            json "Login endpoint mock":
                file "/Users/user1/Mock.json"
            end
            """,
            fileContent: "{}",
            isAbsolutePath: true,
            errors: [
                .jsonFileAbsolutePath
            ]
        )
    }
}
