import XCTest

final class ParserTests: XCTestCase {
    
    func test_empty_source() {
        assert(
            source: "",
            produce: Program(
                suites: []
            )
        )
    }
    
    func test_suite() {
        assert(
            source:
                """
                    suite "HomeScreen":
                        scenario "Open Home Screen":
                            open "homeScreenIdentifier"
                            tap "loginButton"
                            expect "loginScreenIdentifier"
                        end

                        scenario "Open Cart Screen":
                            open "homeScreenIdentifier"
                            tap "addToCart"
                            expect "cartScreenIdentifier"
                            expect "cartItemIdentifier"
                        end
                    end
                
                    suite "Booking Screen":
                        scenario "Open Booking Screen":
                            open "bookingScreenIdentifier"
                            expect "priceViewIdentifier"
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
                                    steps: [
                                        Step(
                                            action: .open,
                                            elementId: "homeScreenIdentifier"
                                        ),
                                        Step(
                                            action: .tap,
                                            elementId: "loginButton"
                                        ),
                                        Step(
                                            action: .expect,
                                            elementId: "loginScreenIdentifier"
                                        )
                                    ]
                                ),
                                Scenario(
                                    name: "Open Cart Screen",
                                    steps: [
                                        Step(
                                            action: .open,
                                            elementId: "homeScreenIdentifier"
                                        ),
                                        Step(
                                            action: .tap,
                                            elementId: "addToCart"
                                        ),
                                        Step(
                                            action: .expect,
                                            elementId: "cartScreenIdentifier"
                                        ),
                                        Step(
                                            action: .expect,
                                            elementId: "cartItemIdentifier"
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
                                    steps: [
                                        Step(
                                            action: .open,
                                            elementId: "bookingScreenIdentifier"
                                        ),
                                        Step(
                                            action: .expect,
                                            elementId: "priceViewIdentifier"
                                        )
                                    ]
                                )
                            ]
                        )
                    ]
                )
        )
    }
}
