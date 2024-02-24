import CustomDump
import XCTest

open class BaseSwiftCodeGenerator_NewTests: XCTestCase {

    func assertName(
        suiteName: String,
        expect name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode(suiteName: suiteName)
        XCTAssertNoDifference(
            result.files[0].name,
            name,
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
                result.files[0].content.contains($0),
                "No expected imports found in the code: \n \"\(result.files[0].content)\"",
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
            result.files[0].content.contains(defenition),
            "No expected class defenition found in the code: \n \"\(result.files[0].content)\"",
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
            result.files[0].content.contains(defenition),
            "No expected method defenition found in the code: \n \"\(result.files[0].content)\"",
            file: file,
            line: line
        )
    }

    func assertPrivateMethodLaunchApp(
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode()
        XCTAssertTrue(
            result.files[0].content.contains(expect),
            "No expected private method 'launchApp' found in the code: \n \"\(result.files[0].content)\"",
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
            result.files[0].content.contains(expect),
            "No expected 'launchApp' call found in the code: \n \"\(result.files[0].content)\"",
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
                result.files[0].content.contains($0),
                "No expected line \($0) of XCtest api call found in the code: \n \"\(result.files[0].content)\"",
                file: file,
                line: line
            )
        }
    }

    func assertPrivateMethodWaitForExistenceIfNeeded(
        expect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try generateCode()
        XCTAssertTrue(
            result.files[0].content.contains(expect),
            "No expected private method 'waitForExistenceIfNeeded' found in the code: \n \"\(result.files[0].content)\"",
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
            result.files[0].content.contains(expect),
            "No expected test method found in the code: \n \"\(result.files[0].content)\"",
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
            result.files[0].content.contains(expect),
            "No expected class found in the code: \n \"\(result.files[0].content)\"",
            file: file,
            line: line
        )
    }

    func assertFullFile(
        source: String,
        expect: Code,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let result = try Lexer(source: source).tokenize()
            .flatMap { Parser(tokens: $0).parse() }
            .flatMap { CodeGenerator(program: $0, SwiftBuilder()).generate() }
            .get()
        XCTAssertNoDifference(
            result,
            expect,
            file: file,
            line: line
        )
    }
}

extension BaseSwiftCodeGenerator_NewTests {

    func generateCode(
        suiteName: String = "Home Scenario",
        scenarioName: String = "Open Home Screen",
        arguments: [String] = [],
        steps: [String] = ["tap button[name: \"Button_1\"]"],
        indentation: Int = 0
    ) throws -> Code {
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
            .flatMap { CodeGenerator(program: $0, SwiftBuilder(indentation: indentation)).generate() }
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
