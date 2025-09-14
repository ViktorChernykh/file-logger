# FileLogger
<p align="center">
<a href="LICENSE">
	<img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
 <a href="https://swift.org">
	<img src="https://img.shields.io/badge/swift-6.0-brightgreen.svg" alt="Swift 6.0">
</a>
 <a href="https://vapor.codes/">
	<img src="https://img.shields.io/badge/vapor-4-brightgreen.svg" alt="Vapor 4">
</a>
 <a href="">
	<img src="https://img.shields.io/badge/platform-macOS|Linux-1A88F5" alt="platform macOS|Linux">
</a>
</p>

Convenience factory for `LoggingSystem.bootstrap`. Returns a closure
that constructs a new `FileLogHandler` for each distinct label.
Thread safety is guaranteed because it is implemented in swift 6.
Used with Vapor.

## Installation

To add a package dependency to Swift Package, add this repository to your list of dependencies.
```swift
.package(url: "https://github.com/ViktorChernykh/file-logger", from: 0.0.1)
```

And to your target as a product:
```swift
.product(name: "FileLogger", package: "file-logger")
```

## Requirements

- macOS 13.0

## Configure:

```swift
import FileLogger

@main
enum Entrypoint {
    static func main() async throws {
        // You don't have to create a folder for the logs.
        // If it does not exist, it will be created automatically at: Resources/Logs.
        // The logs will be written to a new file 'yyyy-mm-dd.log' every day.
        let logDirectory: String = "path to your log directory"
        try await FileSink.shared.setupDirectory(logDirectory)		// optional

        LoggingSystem.bootstrap { label in
            var logHandler: FileLogHandler = .init(label: label, logLevel = .debug)
#if DEBUG
            // In a debug environment, write both to a file and to the console.
            var console: StreamLogHandler = .standardOutput(label: label)
            console.logLevel = .debug
            return MultiplexLogHandler([logHandler, console])
#else
            // In a production environment, writing is done only to a file.
            logHandler.logLevel = .info
            return MultiplexLogHandler([logHandler])
#endif
    }
        let env: Environment = try .detect()
    . . .
}
```

## Usage:

```swift
req.logger.info("Hello FileLogger!")
```
