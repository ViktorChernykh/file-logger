@testable import FileLogger
import Foundation
import Logging
import Testing

// MARK: - Bootstrap swift-log once for tests

/// Minimal in-memory LogHandler to satisfy `LoggingSystem.bootstrap`.
private struct TestLogHandler: LogHandler {
	// Stored label for debugging; not required by the protocol but useful in tests.
	private let label: String

	// Handler-level (global for this logger) log level and metadata.
	public var logLevel: Logger.Level
	public var metadata: Logger.Metadata

	init(label: String = "test", level: Logger.Level = .trace) {
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
		// No-op: we don't assert on emitted lines here.
	}
}

/// Ensure LoggingSystem is bootstrapped exactly once.
private let _bootstrapOnce: Void = {
	LoggingSystem.bootstrap { label in
		TestLogHandler(label: label, level: .trace)
	}
}()

// MARK: - Tests

@Suite("Logger extensions: mergeMetadata & with(metadata:)")
struct LoggerExtensionsTests {

	@Test("mergeMetadata merges and overwrites keys")
	func test_mergeMetadata_overwrite() {
		_ = _bootstrapOnce

		var logger: Logger = .init(label: "merge.test")
		logger[metadataKey: "a"] = .string("1")
		logger[metadataKey: "x"] = .string("orig")

		// Act: merge should add 'b' and overwrite 'x'
		let additional: Logger.Metadata = [
			"b": .string("2"),
			"x": .string("new")
		]
		logger.mergeMetadata(additional)

		// Assert
		#expect(logger[metadataKey: "a"] == .string("1"))
		#expect(logger[metadataKey: "b"] == .string("2"))
		#expect(logger[metadataKey: "x"] == .string("new"))
	}

	@Test("mergeMetadata with empty dictionary does nothing")
	func test_mergeMetadata_emptyNoop() {
		_ = _bootstrapOnce

		var logger: Logger = .init(label: "merge.empty")
		logger[metadataKey: "only"] = .string("keep")

		logger.mergeMetadata([:]) // should be a no-op

		#expect(logger[metadataKey: "only"] == .string("keep"))
		// And nothing new should appear
		#expect(logger[metadataKey: "missing"] == nil)
	}

	@Test("with(metadata:) returns a copy; original remains unchanged (value-semantics handler)")
	func test_withMetadata_independentCopy() {
		_ = _bootstrapOnce

		var original: Logger = .init(label: "with.copy")
		original[metadataKey: "a"] = .string("1")
		original.logLevel = .trace

		// Act: produce a copy with extra metadata (should not mutate 'original')
		let copy: Logger = original.with(metadata: [
			"b": .string("2"),
			"a": .string("over") // overwrite in the copy only
		])

		// Copy sees merged/overwritten keys
		#expect(copy[metadataKey: "a"] == .string("over"))
		#expect(copy[metadataKey: "b"] == .string("2"))

		// Original remains unchanged (because TestLogHandler is a struct -> value semantics)
		#expect(original[metadataKey: "a"] == .string("1"))
		#expect(original[metadataKey: "b"] == nil)

		// Label and level should be preserved in the copy.
		#expect(copy.label == original.label)
		#expect(copy.logLevel == original.logLevel)
	}


	@Test("with(metadata:) on fresh logger does not mutate base (value-semantics handler)")
	func test_withMetadata_doesNotMutateBase() {
		_ = _bootstrapOnce

		let base: Logger = .init(label: "with.fresh")
		let augmented: Logger = base.with(metadata: [
			"k1": .string("v1"),
			"k2": .string("v2")
		])

		// Augmented has keys, base stays pristine.
		#expect(augmented[metadataKey: "k1"] == .string("v1"))
		#expect(augmented[metadataKey: "k2"] == .string("v2"))
		#expect(base[metadataKey: "k1"] == nil)
		#expect(base[metadataKey: "k2"] == nil)
	}
}
