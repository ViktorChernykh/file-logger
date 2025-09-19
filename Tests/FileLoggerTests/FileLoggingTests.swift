@testable import FileLogger
import Logging
import Testing

// MARK: - Test LogHandler that captures the last emitted record

/// Thread-unsafe but sufficient for these unit tests (tests run on a single thread by default).
private final class CaptureLogHandler: LogHandler, @unchecked Sendable {
	// Stored label
	private let label: String

	// Required by the protocol
	public var logLevel: Logger.Level
	public var metadata: Logger.Metadata

	// Captured last call
	struct Record: Sendable {
		let level: Logger.Level
		let message: String
		let metadata: Logger.Metadata?
		let source: String
		let file: String
		let function: String
		let line: UInt
	}

	public private(set) var lastRecord: Record?

	init(label: String = "capture", level: Logger.Level = .trace) {
		self.label = label
		self.logLevel = level
		self.metadata = .init()
	}

	public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
		get { metadata[key] }
		set { metadata[key] = newValue }
	}

	public func log(
		level: Logger.Level,
		message: Logger.Message,
		metadata: Logger.Metadata?,
		source: String,
		file: String,
		function: String,
		line: UInt
	) {
		self.lastRecord = .init(
			level: level,
			message: message.description,
			metadata: metadata,
			source: source,
			file: file,
			function: function,
			line: line
		)
	}
}

// MARK: - Helpers

/// Build a Logger that uses our CaptureLogHandler (class-based -> shared by copies).
@inline(__always)
private func makeCaptureLogger(
	level: Logger.Level = .trace,
	label: String = "tests",
	handlerOut: inout CaptureLogHandler?
) -> Logger {
	let handler: CaptureLogHandler = .init(label: label, level: level)
	handlerOut = handler
	var logger: Logger = Logger(label: label) { _ in handler }
	logger.logLevel = level
	return logger
}

// MARK: - Tests

@Suite("FileLogging helpers: withScopedLogger & time")
struct FileLoggingTests {

	@Test("withScopedLogger merges metadata and passes scoped logger")
	func test_withScopedLogger_metadata() async throws {
		// Given
		var cap: CaptureLogHandler?
		let base: Logger = makeCaptureLogger(handlerOut: &cap)

		// When
		let value: Int = await FileLogging.withScopedLogger(
			base: base,
			metadata: ["req": .string("abc-123"), "tenant": .string("pro")]
		) { scoped in
			// Then: scoped logger contains injected metadata
			#expect(scoped[metadataKey: "req"] == .string("abc-123"))
			#expect(scoped[metadataKey: "tenant"] == .string("pro"))

			// We can still log through it (no assertion needed here)
			scoped.info("inside-scope")
			return 42
		}

		#expect(value == 42)
		// Base logger's handler is shared (class-based), so metadata merged into the passed-in logger remains.
		// NB: copies of `Logger` share the handler; we don't rely on that here beyond successful usage.
		#expect(cap != nil)
	}

	@Test("time emits finished record with op and elapsed_ms, returns result")
	func test_time_success() async throws {
		// Given
		var cap: CaptureLogHandler?
		let logger: Logger = makeCaptureLogger(level: .info, handlerOut: &cap)

		// When
		let result: String = try await FileLogging.time(
			logger: logger,
			level: .info,
			name: "decode_payload",
			metadata: ["instrument": .string("APPL")]
		) {
			try await Task.sleep(nanoseconds: 5_000_000) // 5 ms
			return "OK"
		}

		// Then
		#expect(result == "OK")
		let rec: CaptureLogHandler.Record? = cap?.lastRecord
		#expect(rec != nil)
		#expect(rec?.level == .info)
		// Message should contain "finished"
		#expect(rec?.message.contains("finished") == true)

		// Metadata passed in `log(...)` should include our additional keys
		let md: Logger.Metadata = cap?.metadata ?? [:]
		#expect(md["op"] == .string("decode_payload"))
		#expect(md["instrument"] == .string("APPL"))

		// elapsed_ms should be present and convertible to Double
		if case let .stringConvertible(val)? = md["elapsed_ms"] {
			let s: String = String(describing: val)
			#expect(Double(s) != nil)
		} else if case let .string(s)? = md["elapsed_ms"] {
			#expect(Double(s) != nil)
		} else {
			Issue.record("elapsed_ms missing or wrong type")
		}
	}

	@Test("time emits error record with op, elapsed_ms, error fields and rethrows")
	func test_time_failure() async {
		// Given
		enum Boom: Error { case fail }
		var cap: CaptureLogHandler?
		let logger: Logger = makeCaptureLogger(level: .trace, handlerOut: &cap)

		// When
		do {
			_ = try await FileLogging.time(
				logger: logger,
				level: .debug, // success-level irrelevant here
				name: "failable_stage",
				metadata: ["phase": .string("pre")]
			) {
				try await Task.sleep(nanoseconds: 1_000_000) // 1 ms
				throw Boom.fail
			}
			Issue.record("Expected error, but none was thrown")
		} catch {
			// Then: must be rethrown
			// Check captured error log
			let rec: CaptureLogHandler.Record? = cap?.lastRecord
			#expect(rec != nil)
			#expect(rec?.level == .error)
			#expect(rec?.message.contains("failed") == true)

			let md: Logger.Metadata = cap?.metadata ?? [:]
			#expect(md["op"] == .string("failable_stage"))
			#expect(md["phase"] == .string("pre"))
			if case let .stringConvertible(val)? = md["elapsed_ms"] {
				let s: String = String(describing: val)
				#expect(Double(s) != nil)
			} else if case let .string(s)? = md["elapsed_ms"] {
				#expect(Double(s) != nil)
			} else {
				Issue.record("elapsed_ms missing or wrong type")
			}
			#expect(md["error"] != nil)
			#expect(md["error_type"] != nil)
		}
	}

	@Test("withScopedLogger nested scopes accumulate metadata")
	func test_withScopedLogger_nested() async throws {
		var cap: CaptureLogHandler?
		let base: Logger = makeCaptureLogger(handlerOut: &cap)

		await FileLogging.withScopedLogger(base: base, metadata: ["outer": .string("1")]) { outer in
			#expect(outer[metadataKey: "outer"] == .string("1"))

			await FileLogging.withScopedLogger(base: outer, metadata: ["inner": .string("2")]) { inner in
				#expect(inner[metadataKey: "outer"] == .string("1"))
				#expect(inner[metadataKey: "inner"] == .string("2"))
				inner.debug("nested")
			}
		}
	}
}
