//
//  FileSink.swift
//  file-logger
//
//  Created by Victor Chernykh on 18.05.2025.
//

import Foundation

/// Single-writer actor that buffers log lines in memory and flushes them to disk in batches.
/// A unique instance is created per log-file path so that at most **one** file descriptor is kept open per file.
public actor FileSink {

	// MARK: Static properties

	/// Global shared instance.
	public static let shared: FileSink = .init()

	// MARK: Stored - properties

	/// A file name formatting tool.
	private let dateFormatter: DateFormatter = {
		let formatter: DateFormatter = .init()
		formatter.timeZone = .current
		formatter.locale = .current
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	/// Threshold in bytes at which the buffer is flushed immediately rather than waiting for the periodic timer.
	/// Tune based on workload and I/O characteristics (64 KiB by default).
	private let highWaterMark = 1 << 16		// 64 KiB

	/// The time threshold for logging in `milliseconds`.
	nonisolated
	private let flushIntervalMs = 500

	/// The general directory of logs.
	private var directory: String = ""

	/// Current file name `yyyy-mm-dd`.
	private var fileName: String

	/// The `FileHandle` used for low‑level, append‑only writes. Opened with `O_APPEND`
	/// to ensure each write is atomic on POSIX‑compliant file‑systems.
	private var fileHandle: FileHandle?

	/// In‑memory buffer that accumulates encoded log lines until the next flush.
	private var buffer: Data = .init()

	/// Number of bytes currently sitting in `buffer`. Tracked separately for
	/// performance so we avoid calling `buffer.count` repeatedly.
	private var bufferCount: Int = 0

	/// Prevent spawning multiple immediate flushes in a row.
	private var immediateFlushScheduled: Bool = false

	// MARK: - Init

	/// Opens the file descriptor in append‑only mode and starts the periodic flush loop.
	/// Fatal‑errors on I/O issues because logging should be configured correctly during bootstrap;
	/// failing fast is preferable.
	private init() {
		fileName = dateFormatter.string(from: Date()) + ".log"

		// Kick‑off the background flush loop. The detached task holds a weak
		// reference so it terminates automatically when the actor is de‑init’ed.
		Task.detached(priority: .utility) { [weak self] in
			guard let self else {
				return
			}
			// Schedule periodic flush (every flushIntervalMs).
			try await self.scheduleFlush()
		}
	}

	// MARK: - Configuration

	/// ((Re)opens the log file if `path` differs from the currently opened one.
	/// Should be called **before** the first entry (for example, at the time of bootstrap).
	/// Multiple concurrent calls are safe – the operation is performed only when the path is changed.
	///
	/// - Parameter dir: Absolute path to the log directory.
	public func setupDirectory(_ dir: String) throws {
		let directory = "/" + dir.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
		if self.directory != directory {
			self.directory = directory
		}
		// Create log folder if it doesn't exist
		try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)

		try openFile()
	}

	// MARK: - Internal API

	/// Appends an encoded log line to the in‑memory buffer. If the buffer size
	/// crosses `highWaterMark`, it triggers an immediate flush (debounced).
	///
	/// - Parameter data: UTF‑8 encoded bytes of a single log line.
	func append(_ data: Data) throws {
		buffer.append(data)
		bufferCount += data.count
		// If we crossed threshold — schedule immediate flush only once.
		if bufferCount >= highWaterMark, immediateFlushScheduled == false {
			immediateFlushScheduled = true
			try flush()
			immediateFlushScheduled = false
		}
	}

	// MARK: - Private methods

	func shutdown() throws {
		guard bufferCount > 0 else {
			return
		}
		try fileHandle?.write(contentsOf: buffer)
		buffer.removeAll(keepingCapacity: true)
		bufferCount = 0
		try fileHandle?.close()
	}

	/// Flushes the current buffer to disk. Errors are swallowed because logging
	/// failures should not crash the application; consider reporting via
	/// metrics or stderr in production.
	private func flush() throws {
		guard bufferCount > 0 else {
			return
		}
		try useFile()
		let dataToWrite: Data = buffer
		buffer.removeAll(keepingCapacity: true)
		bufferCount = 0
		try fileHandle?.write(contentsOf: dataToWrite)
	}

	/// Creates the current file name. If it is a new file, it will open it.
	private func useFile() throws {
		let fileName: String = dateFormatter.string(from: Date()) + ".log"
		if self.fileName != fileName {
			self.fileName = fileName
			try openFile()
		}
	}

	/// Opens the file descriptor.
	private func openFile() throws {
		let path: String = "\(directory)/\(fileName)"

		// Close previous handle.
		try? fileHandle?.close() // ignore error – nothing we can do.

		// Open with O_APPEND to guarantee atomic writes.
		let fd: Int32 = open(path, O_CREAT | O_APPEND | O_WRONLY | O_CLOEXEC, 0o640)
		guard fd >= 0 else {
			fatalError("AsyncFileWriter: unable to open \(path): \(String(cString: strerror(errno)))")
		}
		fileHandle = FileHandle(fileDescriptor: fd, closeOnDealloc: true)

		// Seek to EOF once (after restart / rotation).
		try fileHandle?.seekToEnd()
	}

	/// Periodic flush loop that wakes every `flushIntervalMs` milliseconds and writes buffered data to disk.
	/// The loop exits automatically when the surrounding task is
	/// cancelled (e.g., on application shutdown).
	nonisolated
	private func scheduleFlush() async throws {
		while true {
			do {
				try await Task.sleep(for: .milliseconds(flushIntervalMs))
			} catch {
				try await Task.sleep(for: .milliseconds(flushIntervalMs))
			}
			try await flush()
		}
	}
}
