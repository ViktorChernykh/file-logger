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

A high-performance LogHandler for [`swift-log`](https://github.com/apple/swift-log),
which writes logs to disk. Supports JSON (NDJSON, compatible with Loki) and human-readable text.

- Non-blocking asynchronous writing.
- In-memory buffering + periodic flush (timer-based or when the high-water mark is exceeded).
- Automatic file rotation by date (`yyyy-MM-dd.log`).
- Convenient helpers `withScopedLogger` and `time` for wrapping tasks with metadata and duration logging.

## Installation

Add the dependency to `Package.swift`:
```swift
dependencies: [
	.package(url: "https://github.com/ViktorChernykh/file-logger.git", from: "1.0.0")
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "file-logger", package: "file-logger")
        ]
    )
]
```

## Requirements

- Swift 6.0+
- Linux or Apple platforms
- swift-log (added automatically via SPM consumer)

## Bootstrap:

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
			let label: String = "your domain"
#if DEBUG
			let logHandler: FileLogging = .init(label: label, level: .debug, format: .json)
            // In a debug environment, write both to a file and to the console.
            var console: StreamLogHandler = .standardOutput(label: label)
            console.logLevel = .debug
            return MultiplexLogHandler([logHandler, console])
#else
            // In a production environment, writing is done only to a file.
			let logHandler: FileLogHandler = .init(label: label, level: .info, format: .json)
            return MultiplexLogHandler([logHandler])
#endif
		}
        let env: Environment = try .detect()
    . . .
}
```

## Usage:

```swift
req.logger.info("Hello FileLogger!", metadata: ["pid": .string("\(getpid())")])
req.logger.error("Something went wrong")
```

## Output formats
### Plain
```
[2025-09-19T12:34:56.789Z] [info] [main] Application started pid=1234 (main /path/file.swift:func():42)
```
### JSON (NDJSON)
```
{"date":"2025-09-19T12:34:56.789Z","level":"info","label":"main","message":"Application started","metadata":{"pid":"1234"},"source":"main","file":"file.swift","function":"func()","line":42}
```
## Helpers

### Task-scoped logger
```swift
let value: Int = try await FileLogging.withScopedLogger(
    metadata: ["request_id": .string(UUID().uuidString)]
) { scoped in
    scoped.info("Handling request")
    return 42
}
```

### Timed operations
```swift
let result: String = try await FileLogging.time(
    logger: .init(label: "db"),
    level: .info,
    name: "db_query",
    metadata: ["sql": .string("SELECT 1")]
) {
    try await make some job()
}
```
#### Success log:
```
[2025-09-19T12:35:01.123Z] [info] [db] Operation 'db_query' finished sql=SELECT 1 elapsed_ms=5.678
```
#### Failure log:
```
[2025-09-19T12:35:01.123Z] [error] [db] Operation 'db_query' failed sql=SELECT 1 elapsed_ms=5.678 error=... error_type=...
```

## Behavior & tuning
- Rotation: new file every day, named yyyy-MM-dd.log
- Flush: periodic (every 500 ms) or immediate if buffer ≥ 64 KiB
- Atomic writes: open with O_APPEND so each write is atomic on POSIX
- Error handling: background append errors are swallowed; report via metrics if needed
- Formats: JSON uses JSONEncoder with .iso8601, plain uses single-line with `key: value` metadata
	
## License
Please check [LICENSE](LICENSE) for details.
