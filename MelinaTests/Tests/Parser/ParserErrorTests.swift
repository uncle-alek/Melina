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
            throws: .init(expected: .definition, line: 1, offset: 0)
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
            throws:  .init(expected: .end, line: 5, offset: 97)
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
            throws:  .init(expected: .colon, line: 2, offset: 23)
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
            throws: .init(expected: .scenario, line: 2, offset: 24)
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
            throws: .init(expected: .end, line: 3, offset: 88)
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
            throws: .init(expected: .colon, line: 3, offset: 60)
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
            throws: .init(expected: .step, line: 3, offset: 61)
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
            throws: .init(expected: .elementType, line: 3, offset: 65)
        )

        
        assert(
            source:
                """
                suite "HomeScreen":
                    scenario "Open Home Screen":
                        tap button
                    end
                end
                """,
            throws: .init(expected: .elementName, line: 3, offset: 78)
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
            throws: .init(expected: .argumentTo, line: 4, offset: 92)
        )
        
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
            throws: .init(expected: .argumentValue, line: 5, offset: 102)
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
            throws: .init(expected: .argumentKey, line: 5, offset: 109)
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
            throws: .init(expected: .colon, line: 4, offset: 83)
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
            throws: .init(expected: .argumentKey, line: 4, offset: 80)
        )
    }
}
