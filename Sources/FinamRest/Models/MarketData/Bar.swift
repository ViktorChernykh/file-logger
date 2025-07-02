//
//  Bar.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Information about the aggregated candle.
public struct Bar: Codable, Sendable {
	// MARK: Properties

	/// Timestamp of the bar.
	public let timestamp: GoogleTimestamp

	/// Opening price of the bar.
	public let open: GoogleDecimal

	/// Highest price of the bar.
	public let high: GoogleDecimal

	/// Lowest price of the bar.
	public let low: GoogleDecimal

	/// Closing price of the bar.
	public let close: GoogleDecimal

	/// Trading volume in units.
	public let volume: GoogleDecimal

	// MARK: - Init
	public init(
		timestamp: GoogleTimestamp,
		open: GoogleDecimal,
		high: GoogleDecimal,
		low: GoogleDecimal,
		close: GoogleDecimal,
		volume: GoogleDecimal
	) {
		self.timestamp = timestamp
		self.open = open
		self.high = high
		self.low = low
		self.close = close
		self.volume = volume
	}
}
