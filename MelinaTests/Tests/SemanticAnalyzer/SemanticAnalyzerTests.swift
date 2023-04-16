import XCTest

final class SemanticAnalyzerTests: BaseSemanticAnalyzerTests {
    
    func test_suite_name_collision() {
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end

                    tap button[name:"Button_1"]
                end
            end
            
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end

                    tap button[name:"Button_1"]
                end
            end
            
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end

                    tap button[name:"Button_1"]
                end
            end
            """,
            errors: [
                .suiteNameCollision(
                    suite: TestToken(type: .string, lexeme: "Melina", line: 11, startOffset: 177, endOffset:  185)
                ),
                .suiteNameCollision(
                    suite: TestToken(type: .string, lexeme: "Melina", line: 21, startOffset: 348, endOffset: 356)
                )
            ]
        )
    }
    
    func test_scenario_name_collision() {
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end

                    tap button[name:"Button_1"]
                end
                
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end
                    tap button[name:"Button_1"]
                end
            
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end
                    tap button[name:"Button_1"]
                end
            end
            """,
            errors: [
                .scenarioNameCollision(
                    scenario: TestToken(type: .string, lexeme: "First scenario", line: 10, startOffset: 184, endOffset:  200)
                ),
                .scenarioNameCollision(
                    scenario: TestToken(type: .string, lexeme: "First scenario", line: 17, startOffset: 334, endOffset: 350)
                )
            ]
        )
    }
    
    func test_incompatible_action() {
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end

                    tap text[name:"Button_1"]
                end
            end
            """,
            errors: [
                .incompatibleAction(
                    action: TestToken(type: .tap, lexeme: "tap", line: 7, startOffset: 130, endOffset:  133),
                    element: TestToken(type: .text, lexeme: "text", line: 7, startOffset: 134, endOffset:  138)
                )
            ]
        )
        
        assert(
            source:
            """
            suite "Melina":
                scenario "First scenario":
                    arguments:
                        "experiment" : "NewExperiment"
                    end

                    tap searchField[name:"Button_1"]
                end
            end
            """,
            errors: [
                .incompatibleAction(
                    action: TestToken(type: .tap, lexeme: "tap", line: 7, startOffset: 130, endOffset:  133),
                    element: TestToken(type: .searchField, lexeme: "searchField", line: 7, startOffset: 134, endOffset:  145)
                )
            ]
        )
    }
}
