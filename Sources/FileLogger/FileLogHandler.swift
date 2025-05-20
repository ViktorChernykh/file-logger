//
//  FileLogHandler.swift
//  file-logger
//
//  Created by Victor Chernykh on 18.05.2025.
//

import Foundation
import Logging

/// Marks `ISO8601DateFormatter` as `Sendable` because Foundation guarantees
/// its thread‑safety. The annotation is `@unchecked` since the compiler cannot
/// verify this property automatically.
extension ISO8601DateFormatter: @unchecked @retroactive Sendable {}

/// High-throughput `LogHandler` that writes plain text lines to disk
/// asynchronously  via an underlying `FileSink` actor.
public struct FileLogHandler: LogHandler {

	// MARK: Static properties

	/// Cached formatter used to stamp each log line with an ISO‑8601 date/time
	/// string containing fractional‑second precision.
	private let formatter: ISO8601DateFormatter = {
		let f: ISO8601DateFormatter = .init()
		f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		return f
	}()

	// MARK: - Stored properties

	/// The label supplied by SwiftLog, typically identifying the subsystem or
	/// component that emitted the message.
	private let label: String

	/// Actor responsible for batched, non‑blocking writes to the log file.
	private let sink: FileSink = .shared

	// MARK: - LogHandler conformance

	/// The minimum severity level that will be emitted by this handler.
	public var logLevel: Logger.Level

	/// Metadata that will be attached to every log message produced through
	/// this handler, unless overridden at the call‑site.
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
	///   - label: The subsystem/component label assigned by SwiftLog.
	///   - level: Initial minimum log level.
	public init(
		label: String,
		level: Logger.Level
	) {
		self.label = label
		self.logLevel = level
	}

	// MARK: Factory

	/// Convenience factory for `LoggingSystem.bootstrap`. Returns a closure
	/// that constructs a new `FileLogHandler` for each distinct label.
	///
	/// - Parameter level: Default log level threshold.
	/// - Returns: A closure compatible with `LoggingSystem.bootstrap`.
	public static func make(
		level: Logger.Level
	) -> @Sendable (String) -> LogHandler {
		return { label in
			FileLogHandler(
				label: label,
				level: level
			)
		}
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
		let merged: [String: Logger.MetadataValue] = self.metadata.merging(extra ?? [:]) { _, new in
			new
		}

		// Prepend a space only when metadata is non‑empty for cleaner output.
		let meta: String = merged.isEmpty ? "_" : " \(merged)"
		// Compose the final string; keep allocations minimal.
		let context: String = " [\(source):\(file):\(function):\(line)]"
		let timestamp: String = formatter.string(from: Date())
		let string: String = "[\(timestamp)] [\(level.rawValue.uppercased())] [\(label)] [\(message)] [\(meta)] [\(context)]\n"

		let line: Data = .init(string.utf8)

		// Fire‑and‑forget: the append runs on the actor's serial executor.
		Task {
			await sink.append(line)
		}
	}
}
