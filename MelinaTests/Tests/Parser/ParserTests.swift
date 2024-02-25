import XCTest

final class ParserTests: BaseParserTests {
    
    func test_mulitple_suites() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            tap button "Button_1"
                        end

                        scenario "Open Cart Screen":
                            tap button "Button_2"
                        end
                    end
                
                    suite "Booking Screen":
                        scenario "Open Booking Screen":
                            tap button "Button_3"
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Steps:[
                tap-button:Button_1,
                ]
                <Scenario_end>
                <Scenario_begging>:Open Cart Screen
                Steps:[
                tap-button:Button_2,
                ]
                <Scenario_end>
                <Suite_end>
                <Suite_beggining>:Booking Screen
                <Scenario_begging>:Open Booking Screen
                Steps:[
                tap-button:Button_3,
                ]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }
    
    func test_arguments_parsing() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            arguments:
                                "clearState" to "true"
                                "turnOnExperiment" to "true"
                            end
                            tap button "Button_1"
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Arguments:[
                clearState:true,
                turnOnExperiment:true,
                ]
                Steps:[
                tap-button:Button_1,
                ]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }

    func test_actions_parsing() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            verify label "Label_2" is not selected
                            verify view "View_2" is not selected
                            verify view "View_2" is selected
                            verify view "View_2" is exist
                            verify view "View_2" is not exist
                            verify view "View_2" contains value "Hello"
                            tap button "Button 4"
                            edit textfield "Text 1" with text "Hello world"
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Steps:[
                verify-label:Label_2=>is not selected,
                verify-view:View_2=>is not selected,
                verify-view:View_2=>is selected,
                verify-view:View_2=>is exist,
                verify-view:View_2=>is not exist,
                verify-view:View_2=>contains value:Hello,
                tap-button:Button 4,
                edit-textfield:Text 1=>with text:Hello world,
                ]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }

    func test_subscenario_calls_parsing() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            subscenario "Login"
                            subscenario "Logout"
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Steps:[
                subscenario:Login,
                subscenario:Logout,
                ]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }

    func test_subscenario_calls_and_actions_parsing() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            subscenario "Login"
                            tap button "Ok"
                            subscenario "Logout"
                            tap button "Cancel"
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Steps:[
                subscenario:Login,
                tap-button:Ok,
                subscenario:Logout,
                tap-button:Cancel,
                ]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }

    func test_subscenario_definition_parsing() {
        assert(
            source:
                """
                    subscenario "Login":
                        tap button "Login"
                        subscenario "Fill in credentials"
                        tap button "Ok"
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Subscenario_beggining>:Login
                Steps:[
                tap-button:Login,
                subscenario:Fill in credentials,
                tap-button:Ok,
                ]
                <Subscenario_end>
                <Program_end>
                """
        )
    }

    func test_subscenario_definition_and_suite_parsing() {
        assert(
            source:
                """
                    suite "Booking Screen":
                        scenario "Open Booking Screen":
                            subscenario "Login"
                            tap button "Book"
                        end
                    end
                    subscenario "Login":
                        tap button "Login"
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:Booking Screen
                <Scenario_begging>:Open Booking Screen
                Steps:[
                subscenario:Login,
                tap-button:Book,
                ]
                <Scenario_end>
                <Suite_end>
                <Subscenario_beggining>:Login
                Steps:[
                tap-button:Login,
                ]
                <Subscenario_end>
                <Program_end>
                """
        )
    }
}
