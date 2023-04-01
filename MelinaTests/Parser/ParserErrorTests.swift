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
            throws: ParserError(type: .missingSuiteKeyword, line: 1)
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
            throws:  ParserError(type: .missingSuiteName, line: 1)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                        end
                    
                """,
            throws:  ParserError(type: .missingEnd, line: 5)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen"
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws:  ParserError(type: .missingColon, line: 2)
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
            throws: ParserError(type: .missingScenarioKeyword, line: 2)
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
            throws: ParserError(type: .missingScenarioName, line: 2)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                    end
                """,
            throws: ParserError(type: .missingEnd, line: 4)
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
            throws: ParserError(type: .missingColon, line: 3)
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
            throws: ParserError(type: .missingStepAction, line: 3)
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
            throws: ParserError(type: .missingStepElementIdentifier, line: 4)
        )
    }
    
    func test_missing_arguments() {
      
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
            throws: ParserError(type: .missingColon, line: 4)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            arguments:
                                "clear" :
                            end
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError(type: .missingArgumentValue, line: 5)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            arguments:
                                "clear" : "true"
                            open "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError(type: .missingArgumentKey, line: 5)
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
            throws: ParserError(type: .missingColon, line: 4)
        )
    }
}
