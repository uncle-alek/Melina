import CustomDump
import XCTest

open class BaseSwiftCodeGeneratorTest: XCTestCase {

    func assertFileExtension(
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode()
        XCTAssertNoDifference(
            result.fileExtension,
            expect,
            file: file,
            line: line
        )
    }

    func assertImports(
        expect imports: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode()
        imports.forEach {
            XCTAssertTrue(
                result.content.contains($0),
                "No expected imports found in the code: \n \"\(result.content)\"",
                file: file,
                line: line
            )
        }
    }

    func assertClassDefinition(
        suiteName: String,
        expect defenition: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(suiteName: suiteName)
        XCTAssertTrue(
            result.content.contains(defenition),
            "No expected class defenition found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertMethodDefinition(
        scenarioName: String,
        expect defenition: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(scenarioName: scenarioName)
        XCTAssertTrue(
            result.content.contains(defenition),
            "No expected method defenition found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertCallLaunchApp(
        arguments: [String],
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(arguments: arguments)
        XCTAssertTrue(
            result.content.contains(expect),
            "No expected 'launchApp' call found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertCallXCtestApi(
        step: String,
        expect: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(steps: [step])
        expect.forEach {
            XCTAssertTrue(
                result.content.contains($0),
                "No expected line \($0) of XCtest api call found in the code: \n \"\(result.content)\"",
                file: file,
                line: line
            )
        }
    }

    func assertPrivateMethod(
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode()
        XCTAssertTrue(
            result.content.contains(expect),
            "No expected private method found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertFullTestMethod(
        scenarioName: String,
        arguments: [String],
        steps: [String],
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(
            scenarioName: scenarioName,
            arguments: arguments,
            steps: steps
        )
        XCTAssertTrue(
            result.content.contains(expect),
            "No expected test method found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertFullClass(
        suiteName: String,
        scenarioName: String,
        arguments: [String] = [],
        steps: [String],
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(
            suiteName: suiteName,
            scenarioName: scenarioName,
            arguments: arguments,
            steps: steps,
            indentation: 4
        )
        XCTAssertTrue(
            result.content.contains(expect),
            "No expected class found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertFullFile(
        source: String,
        jsonTableEntries: [String:String] = [:],
        expect: File,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let jsonTable = JsonTable()
        jsonTableEntries.forEach { key, value in
            jsonTable.put(key, json: value)
        }
        let result = try Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap {
                CodeGenerator(
                    program: $0,
                    SwiftCodeBuilder(indentation: 4, jsonTable)
                ).generate()
            }
            .get()
        XCTAssertNoDifference(
            result,
            expect,
            file: file,
            line: line
        )
    }

    func assertMethodDefinition(
        subscenarioName: String,
        expect defenition: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(subscenarioName: subscenarioName)
        XCTAssertTrue(
            result.content.contains(defenition),
            "No expected method defenition found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertFullTestMethod(
        subscenarioName: String,
        steps: [String],
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(
            subscenarioName: subscenarioName,
            steps: steps
        )
        XCTAssertTrue(
            result.content.contains(expect),
            "No expected test method found in the code: \n \"\(result.content)\"",
            file: file,
            line: line
        )
    }

    func assertJsonDefinition(
        jsonName: String,
        jsonTableEntries: [String:String],
        expect defenition: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(
            jsonName: jsonName,
            jsonTableEntries: jsonTableEntries
        )
        defenition.forEach {
            XCTAssertTrue(
                result.content.contains($0),
                "No expected json defenition found in the code: \n \"\(result.content)\"",
                file: file,
                line: line
            )
        }
    }
}

extension BaseSwiftCodeGeneratorTest {

    func generateCode(
        suiteName: String = "Home Scenario",
        scenarioName: String = "Open Home Screen",
        arguments: [String] = [],
        steps: [String] = ["tap button \"Button_1\""],
        indentation: Int = 0
    ) throws -> File {
        let source =
                """
                suite "\(suiteName)":
                    scenario "\(scenarioName)":
                        \(generateArguments(arguments))
                        \(generateSteps(steps))
                    end
                end
                """
        return try Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap {
                CodeGenerator(
                    program: $0,
                    SwiftCodeBuilder(indentation: indentation, JsonTable())
                ).generate()
            }
            .get()
    }

    func generateCode(
        subscenarioName: String = "Open Home Screen",
        steps: [String] = ["tap button \"Button_1\""],
        indentation: Int = 0
    ) throws -> File {
        let source =
                """
                subscenario "\(subscenarioName)":
                    \(generateSteps(steps))
                end
                """
        return try Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap {
                CodeGenerator(
                    program: $0,
                    SwiftCodeBuilder(indentation: indentation, JsonTable())
                ).generate()
            }
            .get()
    }

    func generateCode(
        jsonName: String,
        jsonTableEntries: [String:String],
        indentation: Int = 0
    ) throws -> File {
        let source =
                """
                json "\(jsonName)":
                    file "./Mock.json"
                end
                """
        let jsonTable = JsonTable()
        jsonTableEntries.forEach { key, value in
            jsonTable.put(key, json: value)
        }
        return try Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap {
                CodeGenerator(
                    program: $0,
                    SwiftCodeBuilder(indentation: indentation, jsonTable)
                ).generate()
            }
            .get()
    }

    func generateSteps(_ steps: [String]) -> String {
        return steps.isEmpty
        ? ""
        : """
                \(steps.reduce("") { $0 + "\n" + $1 })
          """
    }

    func generateArguments(_ arguments: [String]) -> String {
        return arguments.isEmpty
        ? ""
        : """
            arguments:
                \(arguments.reduce("") { $0 + "\n" + $1 })
            end
          """
    }
}
