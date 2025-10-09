@testable import FileLogger
import Foundation
import Testing

@Suite("FileSink actor", .serialized)
struct FileSinkTests {

	// MARK: - Helpers

	/// Create unique temp directory for each test run.
	private func makeTempDir(_ suffix: String) throws -> String {
		let base: String = NSTemporaryDirectory()
		let path: String = (base as NSString).appendingPathComponent("filesink-\(UUID().uuidString)-\(suffix)")
		try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
		return path
	}

	/// Read file contents as Data if exists.
	private func readFile(_ dir: String, _ fileName: String) throws -> Data? {
		let path: String = (dir as NSString).appendingPathComponent(fileName)
		guard FileManager.default.fileExists(atPath: path) else { return nil }
		return try Data(contentsOf: URL(fileURLWithPath: path))
	}

	/// Compute today file name used by FileSink: yyyy-MM-dd.log (local TZ/locale).
	private func todayFileName() -> String {
		let fmt: DateFormatter = .init()
		fmt.timeZone = .current
		fmt.locale = .current
		fmt.dateFormat = "yyyy-MM-dd"
		let name: String = fmt.string(from: Date())
		return "\(name).log"
	}

	// MARK: - Tests

	@Test("setupDirectory creates folder and shutdown() writes buffered data")
	func test_setup_and_shutdown_writes_buffer() async throws {
		// Given
		let dir: String = try makeTempDir("shutdown")
		let sink: FileSink = .shared
		try await sink.setupDirectory(dir)

		let line: String = "hello-1\n"
		let data: Data = line.data(using: .utf8)! // test-only force unwrap

		// When: below highWaterMark, so only buffered
		try await sink.append(data)

		// Not waiting for periodic flush (500 ms). Force write via shutdown.
		try await sink.shutdown()

		// Then: file exists with exactly our bytes
		let file: String = todayFileName()
		let got: Data? = try readFile("/" + dir.trimmingCharacters(in: CharacterSet(charactersIn: "/")), file)
		#expect(got != nil)
		#expect(got == data)
	}

	@Test("exceeding highWaterMark triggers immediate flush (no duplicate after shutdown)")
	func test_highWaterMark_immediate_flush() async throws {
		// Given
		let dir: String = try makeTempDir("highwater")
		let sink: FileSink = .shared
		try await sink.setupDirectory(dir)

		// Prepare >= 64 KiB payload to cross threshold in a single append.
		let size: Int = 1 << 16 // 65536
		let payload: Data = Data(repeating: 0x58 /* 'X' */, count: size)

		// When: append triggers synchronous flush inside the actor (no need to wait)
		try await sink.append(payload)

		// File should already contain the payload even before shutdown.
		let file: String = todayFileName()
		let path: String = "/" + dir.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/\(file)"
		let attrs: [FileAttributeKey: Any] = try FileManager.default.attributesOfItem(atPath: path)
		let fileSize: Int = (attrs[.size] as? NSNumber)?.intValue ?? -1
		#expect(fileSize == size)

		// Calling shutdown() should NOT duplicate the data because buffer was reset after flush.
		try await sink.shutdown()

		let attrs2: [FileAttributeKey: Any] = try FileManager.default.attributesOfItem(atPath: path)
		let fileSize2: Int = (attrs2[.size] as? NSNumber)?.intValue ?? -1
		#expect(fileSize2 == size)
	}

	@Test("multiple small appends accumulate and are persisted on shutdown")
	func test_multiple_appends_accumulate() async throws {
		// Given
		let dir: String = try makeTempDir("accumulate")
		let sink: FileSink = .shared
		try await sink.setupDirectory(dir)

		// 3 small appends: total well below 64 KiB
		let parts: [String] = ["A\n", "B\n", "C\n"]
		let datas: [Data] = parts.map { $0.data(using: .utf8)! }
		let total: Int = datas.reduce(0) { $0 + $1.count }

		// When
		for piece in datas {
			try await sink.append(piece)
		}

		// Force write without waiting for periodic flush.
		try await sink.shutdown()

		// Then
		let file: String = todayFileName()
		let got: Data? = try readFile("/" + dir.trimmingCharacters(in: CharacterSet(charactersIn: "/")), file)
		#expect(got != nil)
		#expect(got?.count == total)
		let expected: Data = Data(datas.joined())
		#expect(got == expected)
	}

	@Test("setupDirectory normalizes path and creates directory")
	func test_setup_creates_directory() async throws {
		// Given: path with extra slashes (function under test prepends a single leading '/')
		let raw: String = try makeTempDir("mkdir") + "///sub///dir"
		// Clean-up: ensure parent exists, but inner doesn't
		try? FileManager.default.removeItem(atPath: raw)

		let sink: FileSink = .shared

		// When
		try await sink.setupDirectory(raw)

		// Then: normalized absolute directory should exist
		let normalized: String = "/" + raw.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
		var isDir: ObjCBool = false
		let exists: Bool = FileManager.default.fileExists(atPath: normalized, isDirectory: &isDir)
		#expect(exists && isDir.boolValue)
	}
}
