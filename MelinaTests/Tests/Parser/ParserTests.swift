import XCTest

final class ParserTests: BaseParserTests {
    
    func test_empty_string_parsing() {
        assert(
            source:
                "",
            produce:
                """
                <Program_beggining>
                <Program_end>
                """
        )
    }
    
    func test_mulitple_suites() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            tap button[name: "Button_1"]
                        end

                        scenario "Open Cart Screen":
                            tap button[name: "Button_2"]
                        end
                    end
                
                    suite "Booking Screen":
                        scenario "Open Booking Screen":
                            tap button[name: "Button_3"]
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Steps:[tap-button[name:Button_1]]
                <Scenario_end>
                <Scenario_begging>:Open Cart Screen
                Steps:[tap-button[name:Button_2]]
                <Scenario_end>
                <Suite_end>
                <Suite_beggining>:Booking Screen
                <Scenario_begging>:Open Booking Screen
                Steps:[tap-button[name:Button_3]]
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
                                "clearState" : "true"
                                "turnOnExperiment" : "true"
                            end
                
                            tap button[name: "Button_1"]
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Arguments:[clearState:true,turnOnExperiment:true]
                Steps:[tap-button[name:Button_1]]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }
}
