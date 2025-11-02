//
//  FileLogging.swift
//  file-logger
//
//  Created by Victor Chernykh on 18.05.2025.
//

import Foundation
import Logging

/// High-throughput `LogHandler` that writes plain text lines to disk
/// asynchronously  via an underlying `FileSink` actor.
public struct FileLogging: LogHandler {

	/// Codable representation of one log record compatible with swift‑log‑loki.
	private struct LogEntry: Codable {
		let date: Date					// RFC‑3339 / ISO‑8601 timestamp
		let level: String				// log level text (info, error, …)
		let label: String				// subsystem/component label
		let message: String				// user‑supplied message
		let metadata: [String: String]?	// flattened metadata dictionary
		let source: String
		let file: String
		let function: String
		let line: UInt
	}

	/// Output format for emitted log lines.
	public enum OutputFormat: Sendable {
		case json   // NDJSON: one JSON object per line
		case plain  // Human‑readable single‑line text
	}

	// MARK: - Stored properties

	/// The label supplied by SwiftLog, typically identifying the `subsystem` or
	/// component that emitted the message.
	private let label: String

	/// Actor responsible for batched, non‑blocking writes to the log file.
	private let sink: FileSink

	/// Selected output format.
	private let format: OutputFormat

	// MARK: - LogHandler conformance

	/// The minimum severity level that will be emitted by this handler.
	public var logLevel: Logger.Level

	/// Metadata that will be attached to every log message produced through this handler,
	/// unless overridden at the call‑site.
	public var metadata: Logger.Metadata = [:]

	/// Dynamic subscript for reading and writing individual metadata keys.
	public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
		get {
			metadata[key]
		}
		set {
			metadata[key] = newValue
		}
	}

	// MARK: - Init

	/// Creates a fully‑configured log handler.
	/// The handler delegates I/O to the shared `FileSink` actor so
	/// that callers never block on disk operations.
	///
	/// - Parameters:
	///   - directory: Directory where the log files will be stored. A `FileSink` will write into this directory.
	///   - label: The subsystem/component label assigned by SwiftLog.
	///   - level: Initial minimum log level threshold for this handler.
	///   - format: Output encoding for each log line (`.json` NDJSON or `.plain` human‑readable).
	public init(
		directory: String,
		label: String,
		level: Logger.Level,
		format: OutputFormat
	) {
		self.label = label
		self.logLevel = level
		self.format = format
		self.sink = FileSink(directory)
	}

	// MARK: Factory

	/// Convenience factory intended for `LoggingSystem.bootstrap`.
	/// Returns a closure that creates a new `FileLogging` per label.
	///
	/// - Parameters:
	///   - directory: Directory where the log files will be stored.
	///   - level: Default minimum log level for handlers created by the closure.
	///   - format: Output encoding for each log line produced by the handlers.
	/// - Returns: A closure that accepts a `label` and returns a configured `FileLogging` for that label.
	public static func make(
		directory: String,
		level: Logger.Level,
		format: OutputFormat
	) -> @Sendable (String) -> any LogHandler {
		return { label in
			FileLogging(
				directory: directory,
				label: label,
				level: level,
				format: format
			)
		}
	}

	/// Prepares the underlying `FileSink` and ensures the target directory exists.
	/// Call this once during application bootstrap before emitting logs.
	///
	/// - Parameter directory: Optional directory override for this setup call. If `nil`, uses the directory passed to the initializer.
	/// - Throws: Any error encountered while creating the directory or opening the file.
	public func setup(directory: String? = nil) async throws {
		try await sink.setup(directory: directory)
	}

	/// Logs a single message. Execution never blocks because the encoded line
	/// is enqueued to the `FileSink` actor.
	///
	/// - Parameters:
	///   - level: Severity of the message.
	///   - message: User‑supplied text.
	///   - extra: Call‑site metadata to merge with the handler‑level metadata.
	///   - source: Identifier of the logging source.
	///   - file: File from which the call originated.
	///   - function: Function from which the call originated.
	///   - line: Source line number.
	public func log(
		level: Logger.Level,
		message: Logger.Message,
		metadata extra: Logger.Metadata?,
		source: String,
		file: String,
		function: String,
		line: UInt
	) {
		// Skip messages below the current level.
		guard level >= logLevel else {
			return
		}

		// Merge static + call-site metadata.
		let merged: [String: Logger.MetadataValue] = metadata.merging(extra ?? [:])

		// Flatten metadata so it is JSON‑encodable.
		let sanitizedMetadata: [String: String]? = merged.isEmpty
			? nil
			: merged.mapValues { "\($0)" }

		let data: Data
		switch format {
		case .json:
			// Build structured payload expected by Loki NDJSON.
			let entry: LogEntry = .init(
				date: Date(),
				level: level.rawValue,
				label: label,
				message: message.description,
				metadata: sanitizedMetadata,
				source: source,
				file: file,
				function: function,
				line: line
			)
			// Use a fresh encoder to avoid any thread-safety concerns.
			let encoder: JSONEncoder = {
				let encoder: JSONEncoder = .init()
				encoder.outputFormatting = [.withoutEscapingSlashes]
				encoder.dateEncodingStrategy = .iso8601
				return encoder
			}()
			guard var encoded: Data = try? encoder.encode(entry) else {
				// In DEBUG you can output to stderr.
				return
			}
			encoded.append(0x0A) // '\n'
			data = encoded
		case .plain:
			let iso8601: ISO8601DateFormatter = {
				let f: ISO8601DateFormatter = .init()
				f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
				return f
			}()
			let timestamp: String = iso8601.string(from: Date())

			// Human‑readable single line. Metadata rendered as key=value pairs.
			let levelText: String = level.rawValue.uppercased()
			let metaText: [String: String] = {
				guard !merged.isEmpty else {
					return [:]
				}
				return merged.mapValues { "\($0)" }
			}()

			let contextText: String = " (\(source) \(file):\(function):\(line))"
			let lineString: String = "[\(timestamp)] [\(levelText)] [\(label)] \(message.description)\(metaText)\(contextText)\n"
			guard let encoded: Data = lineString.data(using: .utf8) else {
				return
			}
			data = encoded
		}

		// Fire‑and‑forget: the append runs on the actor's serial executor.
		Task {
			do {
				try await sink.append(data)
			} catch {
				print(error.localizedDescription)
			}
		}
	}

	/// Run an async body with a Task-scoped logger that optionally adds metadata.
	/// The logger is available via Task-local storage to any code that knows how to fetch it.
	///
	///		let value: Int = try await FileLogging.withScopedLogger(
	///			metadata: ["job": .string("daily_import"), "shard": .string("A")]
	///		) { logger in
	///			logger.info("Starting import")
	///			// ... your code ...
	///			return 42
	///		}
	///
	/// - Parameters:
	///   - base: Base Logger to derive from. If nil, a new Logger(label: "file-logger") is created.
	///   - metadata: Additional metadata to merge into the logger before executing the body.
	///               Keys in this dictionary override matching keys already present in the logger.
	///   - body: Async function executed within the scope of the Task-local logger.
	///           The configured scoped logger is passed to this closure.
	/// - Returns: The result returned by the body.
	@discardableResult
	public static func withScopedLogger<T: Sendable>(
		base: Logger? = nil,
		metadata: Logger.Metadata = .init(),
		_ body: @escaping @Sendable (_ scoped: Logger) async throws -> T
	) async rethrows -> T {
		// Create base logger if none was supplied.
		var scoped: Logger = base ?? Logger(label: "file-logger")
		if metadata.isEmpty == false {
			scoped.mergeMetadata(metadata)
		}
		return try await FileLogTaskContext.$current.withValue(scoped) {
			try await body(scoped)
		}
	}

	/// Time the execution of an async operation and log its duration.
	/// Uses the provided logger or, if nil, falls back to the Task-scoped logger,
	/// and finally to a default `file-logger` label.
	///
	///		let result: String = try await FileLogging.time(
	///			logger: Logger(label: "ingest"),
	///			level: .info,
	///			name: "batch_parse",
	///			metadata: ["instrument": .string("APPL")]
	///		) {
	///			// ... your code ...
	///			return "OK"
	///		}
	///
	/// - Parameters:
	///   - logger: Logger instance to write timing messages to. If nil, uses the Task-local
	///             logger when available, otherwise Logger(label: "file-logger").
	///   - level: Log level for the success message. Defaults to `.debug`.
	///   - name: Human-readable operation name used in the log message and as metadata ("op").
	///   - metadata: Additional metadata to include alongside "op" and "elapsed_ms".
	///               Values here do not overwrite the internal keys used by this helper.
	///   - body: Async operation whose execution time will be measured.
	/// - Returns: The result returned by the body.
	/// - Throws: Rethrows any error thrown by the body. An error log is emitted in that case.
	@inline(__always)
	public static func time<T: Sendable>(
		logger: Logger? = nil,
		level: Logger.Level = .debug,
		name: String,
		metadata: Logger.Metadata = .init(),
		_ body: @escaping @Sendable () async throws -> T
	) async rethrows -> T {
		let active: Logger = logger ?? (FileLogTaskContext.current ?? Logger(label: "file-logger"))
		let start: ContinuousClock.Instant = .now
		do {
			let result: T = try await body()
			let end: ContinuousClock.Instant = .now
			let duration: Duration = start.duration(to: end)
			let log: Logger = active.with(metadata: metadata.merging([
				"op": .string(name),
				"elapsed_ms": .stringConvertible(_ms(duration))
			]))
			log.log(level: level, "Operation '\(name)' finished")
			return result
		} catch {
			let end: ContinuousClock.Instant = .now
			let duration: Duration = start.duration(to: end)
			let log: Logger = active.with(metadata: metadata.merging([
				"op": .string(name),
				"elapsed_ms": .stringConvertible(_ms(duration)),
				"error": .string(String(describing: error)),
				"error_type": .string(String(describing: type(of: error)))
			]))
			log.error("Operation '\(name)' failed")
			throw error
		}
	}

	/// Format a Duration value as milliseconds with three decimal places (e.g., "12.345").
	///
	/// - Parameter duration: Time interval to convert to milliseconds.
	/// - Returns: String containing the total milliseconds rounded to thousandths.
	@inline(__always)
	private static func _ms(_ duration: Duration) -> Double {
		let comps: (seconds: Int64, attoseconds: Int64) = duration.components
		let msFromSec: Double = Double(comps.seconds) * 1_000.0
		let msFromAttos: Double = Double(comps.attoseconds) / 1_000_000_000_000_000.0

		return msFromSec + msFromAttos
	}
}
