@testable import FileLogger
import Foundation
import Logging
import Testing

@Suite("Logger.Metadata merging()")
struct LoggerMetadataMergingTests {

	@Test("merging two empty dictionaries yields empty")
	func test_merging_bothEmpty() {
		let lhs: Logger.Metadata = [:]
		let rhs: Logger.Metadata = [:]

		let result: Logger.Metadata = lhs.merging(rhs)

		#expect(result.isEmpty)
	}

	@Test("merging when self is empty returns other")
	func test_merging_selfEmpty() {
		let lhs: Logger.Metadata = [:]
		let rhs: Logger.Metadata = ["k1": .string("v1")]

		let result: Logger.Metadata = lhs.merging(rhs)

		#expect(result == rhs)
	}

	@Test("merging when other is empty returns self")
	func test_merging_otherEmpty() {
		let lhs: Logger.Metadata = ["a": .string("x")]
		let rhs: Logger.Metadata = [:]

		let result: Logger.Metadata = lhs.merging(rhs)

		#expect(result == lhs)
	}

	@Test("merging with overwrite replaces existing keys")
	func test_merging_withOverwrite() {
		let lhs: Logger.Metadata = [
			"a": .string("orig"),
			"b": .string("keep")
		]
		let rhs: Logger.Metadata = [
			"a": .string("new"),
			"c": .string("add")
		]

		let result: Logger.Metadata = lhs.merging(rhs)

		// 'a' should be overwritten
		#expect(result["a"] == .string("new"))
		// 'b' stays untouched
		#expect(result["b"] == .string("keep"))
		// 'c' should be added
		#expect(result["c"] == .string("add"))
	}

	@Test("merging preserves both dictionaries when keys disjoint")
	func test_merging_disjoint() {
		let lhs: Logger.Metadata = ["x": .string("1")]
		let rhs: Logger.Metadata = ["y": .string("2")]

		let result: Logger.Metadata = lhs.merging(rhs)

		#expect(result["x"] == .string("1"))
		#expect(result["y"] == .string("2"))
	}
}
