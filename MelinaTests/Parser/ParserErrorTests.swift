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
            throws: ParserError(expected: .suiteKeyword, line: 1)
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
            throws:  ParserError(expected: .suiteName, line: 1)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            verify "homeScreenIdentifier" text
                        end
                    
                """,
            throws:  ParserError(expected: .suiteEnd, line: 5)
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
            throws:  ParserError(expected: .suiteColon, line: 2)
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
            throws: ParserError(expected: .scenarioKeyword, line: 2)
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
            throws: ParserError(expected: .scenarioName, line: 2)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            verify "homeScreenIdentifier" text
                """,
            throws: ParserError(expected: .scenarioEnd, line: 3)
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
            throws: ParserError(expected: .scenarioColon, line: 3)
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
            throws: ParserError(expected: .stepAction, line: 3)
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
            throws: ParserError(expected: .stepElement, line: 4)
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
            throws: ParserError(expected: .stepElementIdentifier, line: 3)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                        end
                    end
                """,
            throws: ParserError(expected: .stepAction, line: 3)
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
            throws: ParserError(expected: .argumentColon, line: 4)
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
            throws: ParserError(expected: .argumentValue, line: 5)
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
            throws: ParserError(expected: .argumentKey, line: 5)
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
            throws: ParserError(expected: .argumentsColon, line: 4)
        )
        
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            arguments:
                            end
                            verify "homeScreenIdentifier" text
                        end
                    end
                """,
            throws: ParserError(expected: .argumentKey, line: 4)
        )
    }
}
