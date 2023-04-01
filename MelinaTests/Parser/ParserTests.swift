import XCTest

final class ParserTests: XCTestCase {
    
    func test_empty_string_parsing() {
        assert(
            source: "",
            produce: Program(
                suites: []
            )
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
                Program(
                    suites: [
                        Suite(
                            name: "HomeScreen",
                            scenarios: [
                                Scenario(
                                    name: "Open Home Screen",
                                    arguments: [],
                                    steps: [
                                        Step(
                                            action: .verify,
                                            elementId: "homeScreenIdentifier",
                                            element: .text
                                        )
                                    ]
                                ),
                                Scenario(
                                    name: "Open Cart Screen",
                                    arguments: [],
                                    steps: [
                                        Step(
                                            action: .verify,
                                            elementId: "homeScreenIdentifier",
                                            element: .text
                                        )
                                    ]
                                )
                            ]
                        ),
                        Suite(
                            name: "Booking Screen",
                            scenarios: [
                                Scenario(
                                    name: "Open Booking Screen",
                                    arguments: [],
                                    steps: [
                                        Step(
                                            action: .verify,
                                            elementId: "homeScreenIdentifier",
                                            element: .text
                                        )
                                    ]
                                )
                            ]
                        )
                    ]
                )
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
                Program(
                    suites: [
                        Suite(
                            name: "HomeScreen",
                            scenarios: [
                                Scenario(
                                    name: "Open Home Screen",
                                    arguments: [
                                        Argument(
                                            key: "clearState",
                                            value: "true"
                                        ),
                                        Argument(
                                            key: "turnOnExperiment",
                                            value: "true"
                                        )
                                    ],
                                    steps: [
                                        Step(
                                            action: .verify,
                                            elementId: "homeScreenIdentifier",
                                            element: .text
                                        )
                                    ]
                                ),
                            ]
                        )
                    ]
                )
        )
    }
}
