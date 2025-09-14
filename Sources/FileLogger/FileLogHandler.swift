//
//  FileLogHandler.swift
//  file-logger
//
//  Created by Victor Chernykh on 18.05.2025.
//

import Foundation
import Logging

/// Marks `ISO8601DateFormatter` as `Sendable` because Foundation guarantees its thread‑safety.
/// The annotation is `@unchecked` since the compiler cannot verify this property automatically.
extension ISO8601DateFormatter: @unchecked @retroactive Sendable {}

/// High-throughput `LogHandler` that writes plain text lines to disk
/// asynchronously  via an underlying `FileSink` actor.
public struct FileLogHandler: LogHandler {

	/// Codable representation of one log record compatible with swift‑log‑loki.
	private struct LogEntry: Codable {
		let ts: String					// RFC‑3339 / ISO‑8601 timestamp
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

	/// Cached formatter used to stamp each log line with an ISO‑8601 date/time
	/// string containing fractional‑second precision.
	private let formatter: ISO8601DateFormatter = {
		let f: ISO8601DateFormatter = .init()
		f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		return f
	}()

	/// Shared JSONEncoder used to serialize each log line for Loki (NDJSON).
	private let encoder: JSONEncoder = {
		let e: JSONEncoder = .init()
		e.outputFormatting = [.withoutEscapingSlashes]
		return e
	}()

	/// The label supplied by SwiftLog, typically identifying the `subsystem` or
	/// component that emitted the message.
	private let label: String

	/// Actor responsible for batched, non‑blocking writes to the log file.
	private let sink: FileSink = .shared

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
	///   - label: The subsystem/component label assigned by SwiftLog.
	///   - level: Initial minimum log level.
	public init(
		label: String,
		level: Logger.Level,
		format: OutputFormat
	) {
		self.label = label
		self.logLevel = level
		self.format = format
	}

	// MARK: Factory

	/// Convenience factory for `LoggingSystem.bootstrap`. Returns a closure
	/// that constructs a new `FileLogHandler` for each distinct label.
	///
	/// - Parameter level: Default log level threshold.
	/// - Returns: A closure compatible with `LoggingSystem.bootstrap`.
	public static func make(
		level: Logger.Level,
		format: OutputFormat
	) -> @Sendable (String) -> LogHandler {
		return { label in
			FileLogHandler(
				label: label,
				level: level,
				format: format
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

		// Flatten metadata so it is JSON‑encodable.
		let sanitizedMetadata: [String: String]? = merged.isEmpty
			? nil
			: merged.mapValues { "\($0)" }

		let timestamp: String = formatter.string(from: Date())

		let data: Data
		switch format {
		case .json:
			// Build structured payload expected by Loki NDJSON.
			let entry: LogEntry = .init(
				ts: timestamp,
				level: level.rawValue,
				label: label,
				message: message.description,
				metadata: sanitizedMetadata,
				source: source,
				file: file,
				function: function,
				line: line
			)
			// Encode as single‑line JSON (NDJSON) and append newline.
			guard var encoded: Data = try? encoder.encode(entry) else {
				return
			}
			encoded.append(0x0A) // '\n'
			data = encoded
		case .plain:
			// Human‑readable single line. Metadata rendered as key=value pairs.
			let levelText: String = level.rawValue.uppercased()
			let metaText: String = {
				guard let dict: [String: String] = sanitizedMetadata, !dict.isEmpty else {
					return ""
				}
				let pairs: [String] = dict.sorted { $0.key < $1.key }.map { key, value in
					"\(key)=\(value)"
				}
				return " " + pairs.joined(separator: " ")
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
			await sink.append(data)
		}
	}
}
