
Convenience factory for `LoggingSystem.bootstrap`. Returns a closure
that constructs a new `FileLogHandler` for each distinct label. Used with Vapor.

Configure:

```swift
import FileLogger

@main
enum Entrypoint {
    static func main() async throws {
        // Logs directory. Logs will be written to a new file 'yyyy-mm-dd.log' every day.
        let logDirectory: String = "path to your log directory"

        // You don't have to create a folder.
        // If it doesn't exist, it will be created automatically.
        try await FileSink.shared.setupDirectory(logDirectory)

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

Usage:

```swift
req.logger.info("Hello FileLogger!")
```
