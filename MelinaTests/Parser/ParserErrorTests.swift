import Foundation
import XCTest

final class ParserErrorTests: XCTestCase {
    
    func test_missing_suite() {
        assert(
            source:
                """
                    "HomeScreen":
                        scenario "Open Home Screen":
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
                        end
                    
                """,
            throws:  ParserError(type: .missingEnd, line: 5)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen"
                        scenario "Open Home Screen":
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
                    end
                """,
            throws: ParserError(type: .missingEnd, line: 4)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen"
                            verify "homeScreenIdentifier" text
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
                            "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier"
                        end
                    end
                """,
            throws: ParserError(type: .missingStepElement, line: 4)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            verify text
                        end
                    end
                """,
            throws: ParserError(type: .missingStepElementIdentifier, line: 3)
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
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
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
                            verify "homeScreenIdentifier" text
                        end
                    end
                """,
            throws: ParserError(type: .missingColon, line: 4)
        )
    }
}
