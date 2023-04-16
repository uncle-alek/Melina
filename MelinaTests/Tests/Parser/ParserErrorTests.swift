import Foundation
import XCTest

final class ParserErrorTests: BaseParserTests {
    
    func test_missing_suite() {
        assert(
            source:
                """
                "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .suiteKeyword, line: 1, offset: 0)
        )
        
        assert(
            source:
                """
                suite :
                    scenario "Open Home Screen":
                        tap button[name: "Button_1"]
                    end
                end
                """,
            throws:  .init(expected: .suiteName, line: 1, offset: 6)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[name: "Button_1"]
                    end
                
                """,
            throws:  .init(expected: .suiteEnd, line: 5, offset: 97)
        )
        
        assert(
            source:
                """
                suite "HomeScreen"
                    scenario "Open Home Screen":
                        tap button[name: "Button_1"]
                    end
                end
                """,
            throws:  .init(expected: .suiteColon, line: 2, offset: 23)
        )
    }
    
    func test_missing_scenario() {
        assert(
            source:
                """
                suite "HomeScreen":
                    "Open Home Screen":
                        tap button[name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .scenarioKeyword, line: 2, offset: 24)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario :
                        tap button[name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .scenarioName, line: 2, offset: 33)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[name: "Button_1"]
                """,
            throws: .init(expected: .scenarioEnd, line: 3, offset: 88)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen"
                        tap button[name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .scenarioColon, line: 3, offset: 60)
        )
    }
    
    func test_missing_step() {
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        button[name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .stepAction, line: 3, offset: 61)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap [name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .stepElement, line: 3, offset: 65)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button name: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .stepLeftSquareBrace, line: 3, offset: 72)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[: "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .stepElementNameKeyword, line: 3, offset: 72)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[name "Button_1"]
                    end
                end
                """,
            throws: .init(expected: .stepElementColon, line: 3, offset: 77)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[name: ]
                    end
                end
                """,
            throws: .init(expected: .stepElementName, line: 3, offset: 78)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button[name: "Button_1"
                    end
                end
                """,
            throws: .init(expected: .stepRightSquareBrace, line: 4, offset: 93)
        )
        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                    end
                end
                """,
            throws: .init(expected: .stepAction, line: 3, offset: 57)
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
            throws: .init(expected: .argumentColon, line: 4, offset: 92)
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
            throws: .init(expected: .argumentValue, line: 5, offset: 102)
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
            throws: .init(expected: .argumentKey, line: 5, offset: 109)
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
            throws: .init(expected: .argumentsColon, line: 4, offset: 83)
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
            throws: .init(expected: .argumentKey, line: 4, offset: 80)
        )
    }
}
