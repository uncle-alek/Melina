import Foundation

import XCTest

final class ParserErrorTests: XCTestCase {
    
    func test_missing_suite() {
        assert(
            source:
                """
                    "HomeScreen":
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingSuiteKeyword
        )
        
        assert(
            source:
                """
                    suite :
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingSuiteName
        )
    }
    
    func test_missing_scenario() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        "Open Home Screen":
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingScenarioKeyword
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario :
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingScenarioName
        )
    }
    
    func test_missing_step() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingStepAction
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            open
                        end
                    end
                """,
            throws: ParserError.missingStepElementIdentifier
        )
    }
    
    func test_missing_colon() {
        assert(
            source:
                """
                    suite "HomeScreen"
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingColon
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen"
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingColon
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            arguments
                                "clear" : "true"
                            end
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingColon
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            arguments:
                                "clear" "true"
                            end
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError.missingColon
        )
    }
}
