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
4. Once cloned, navigate into the Melina repository directory:
```shell
cd ./Melina
5. Open the project in Xcode by double-clicking the project file, or using the following command:
```shell
open -a Xcode Melina.xcodeproj
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

Running the command without specifying the `--output` option:

```shell
melina -p ./spec/test_spec.melina -l swift
