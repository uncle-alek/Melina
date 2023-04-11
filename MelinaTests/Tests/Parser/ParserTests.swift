import XCTest

final class ParserTests: BaseParserErrorTests {
    
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
                            verify "homeScreenIdentifier" text
                        end

                        scenario "Open Cart Screen":
                            verify "homeScreenIdentifier" text
                        end
                    end
                
                    suite "Booking Screen":
                        scenario "Open Booking Screen":
                            verify "homeScreenIdentifier" text
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Steps:[verify-homeScreenIdentifier-text]
                <Scenario_end>
                <Scenario_begging>:Open Cart Screen
                Steps:[verify-homeScreenIdentifier-text]
                <Scenario_end>
                <Suite_end>
                <Suite_beggining>:Booking Screen
                <Scenario_begging>:Open Booking Screen
                Steps:[verify-homeScreenIdentifier-text]
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
                
                            verify "homeScreenIdentifier" text
                        end
                    end
                """,
            produce:
                """
                <Program_beggining>
                <Suite_beggining>:HomeScreen
                <Scenario_begging>:Open Home Screen
                Arguments:[clearState:true,turnOnExperiment:true]
                Steps:[verify-homeScreenIdentifier-text]
                <Scenario_end>
                <Suite_end>
                <Program_end>
                """
        )
    }
}
