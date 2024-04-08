![Melina_logo](https://user-images.githubusercontent.com/12128692/232309623-ea0a8dab-5c1e-41b5-9674-a497a2b7f4c7.png)


# Melina is a platform agnostic DSL for UI testing

Melina is a command-line tool designed to generate code for UI tests. It is built to convert a test specification into code in the language of your choice, currently supporting Swift or a "byte code" version known as SwiftTeCode.

## Features

- Command-line utility for code generation
- Support for Swift and SwiftTeCode languages
- Customizable output file paths

## Installation

To install Melina, you will need to clone the repository from GitHub and compile it using Xcode. Follow the steps below:

1. Open Terminal on your Mac.
2. Navigate to the directory where you want to clone Melina using the `cd` command.
3. Clone the repository with the following command:
```shell
git clone git@github.com:uncle-alek/Melina.git
```
4. Once cloned, navigate into the Melina repository directory:
```shell
cd ./Melina
```
5. Open the project in Xcode by double-clicking the project file, or using the following command:
```shell
open -a Xcode Melina.xcodeproj
```
6. Compile the project in Xcode by clicking on the Build button or using the shortcut ⌘B.
After successfully compiling the project, the Melina command-line tool will be ready to use on your system.

## Usage

To use Melina, run the `melina` command followed by the necessary options.

### Options

- `-p, --path`: Specifies the path to the test specification.
- `-l, --lang`: Indicates the language for the generated code (`swift` or `swiftTeCode`).
- `-o, --output`: Defines the output file path. If not provided, Melina will automatically create the generated code file in the same directory as the input file, maintaining the original file name but with an extension that matches the chosen language for the generated code.

### Example Command

To generate Swift code from a test specification located at `./spec/test_spec.melina` and output to `./GeneratedTests/UITest.swift`, use the following command:

```shell
melina -p ./spec/test_spec.melina -l swift -o ./GeneratedTests/UITest.swift
```

Running the command without specifying the `--output` option:

```shell
melina -p ./spec/test_spec.melina -l swift
```

# Guide to writing test specs with Melina

## Key components of the DSL

Before you start, familiarize yourself with the key components:

- **Suite**: A collection of scenarios (test cases) that are grouped together.
- **Scenario**: An individual test case with a series of steps to execute.
- **Subscenario**: A reusable set of steps that can be included in multiple scenarios.
- **Arguments(Optional)**: Arguments are parameters for the application under test.
- **Step**: A single action or check performed in the test.
- **Action**: An interaction with an element (e.g., tap, edit).
- **Element**: A part of the UI such as a button or text field.
- **Condition**: A verification step to assert the state of an element (e.g., is visible, contains text).
- **Comments**: Can be used to add descriptive text to test specifications.

## Writing a test specification

Start by defining the test suite, then the scenarios within it, and the steps for each scenario.

### Define a suite

A suite encapsulates several related scenarios:

```
suite "Name of Feature to Test":
    ...
end
```

### Define a scenario

Each scenario represents a specific flow or case you want to test:

```
scenario "Descriptive Name of the Scenario":
    ...
end
```

### Using arguments

Use arguments in the beggining of your scenario by providing key value pairs:

```
arguments:
    "argument key" to "value"
    "another argument key" to "another value"
end
```

### Define steps in a scenario

Steps are the actions or checks you want to perform:

```
tap button "LoginButton"
verify label "WelcomeMessage" contains "Welcome"
```

### Define subscenarios

For common sequences of steps, define a subscenario once and reuse it:

```
subscenario "LoginProcess":
    ...
end
```

And call it within a scenario:

```
subscenario "LoginProcess"
```

### Conditions

Assert the state of elements as part of your test steps like so:

```
verify button "Ok" selected
```

## Example of a Complete Test Spec

Here's how a complete test spec might look:

```
suite "User Authentication":

    scenario "Valid User Login":
        arguments:
            "mock api" to "success"
        end
        // Reuse the subscenario
        subscenario "Complete Login Process"
        verify view "WelcomeMessage" contains "Welcome, testuser!"
    end

    scenario "Invalid User Login":
        arguments:
            "mock api" to "fail"
        end
        // Reuse the subscenario
        subscenario "Complete Login Process"
        verify label "ErrorMessage" contains "Invalid credentials"
    end

end

subscenario "Complete Login Process":
    tap button "LoginButton"
    edit textfield "UsernameField" with "providedUsername"
    edit textfield "PasswordField" with "providedPassword"
end
```

### Using comments

In Melina used only single-line comments:

```
// This comment explaining the following action
tap button "LoginButton"
```

# Actions, Elements, and Conditions

The following table outlines the available elements and conditions that can be used in combination with each action.

| Action  |  Elements                      | Conditions Without Parameters  | Conditions With Parameters |
|---------|--------------------------------|--------------------------------|----------------------------|
| tap     | button                         | -                              | -                          |
| verify  | button, label, textfield, view | exists, not exists,<br>selected, not selected<br>| contains {parameter} |
| edit    | textfield                      | -                              | with {parameter}           |

Note:
- 'Conditions Without Parameters' are conditions that do not require an additional parameter.
- 'Conditions With Parameters' are conditions that require an additional parameter.
- 'parameter' is a expected text.

## Conclusion

Now that you know the basics, you can start writing your own test specifications. Remember, the key is to describe what you want to test in simple, logical steps.
