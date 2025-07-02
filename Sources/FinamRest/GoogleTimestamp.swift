//
//  GoogleTimestamp.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

import Foundation

/// `google.type.Timestamp`
public struct GoogleTimestamp: Codable, Sendable {
	// MARK: Properties

	public let seconds: Int
	public let nanos: Int

	public var dateFormat: String {
		let date: Date = .init(timeIntervalSinceReferenceDate: Double(seconds))
		return Constants.finamDateFormatter.string(from: date)
	}

	// MARK: - Init
	public init(seconds: Int, nanos: Int) {
		self.seconds = seconds
		self.nanos = nanos
	}

	public init(date: Date) {
		// `TimeInterval` is a typealias for `Double` representing seconds.
		let interval: TimeInterval = date.timeIntervalSince1970

		// `modf` splits `interval` into integral and fractional parts.
		let (secondsPart, fractionalPart) = modf(interval)

		// Convert the integral part to an `Int` for seconds.
		self.seconds = .init(secondsPart)

		// Multiply the fractional part by 1_000_000_000 to get nanoseconds and round to the nearest integer.
		self.nanos = .init((fractionalPart * 1_000_000_000).rounded())
	}
}
