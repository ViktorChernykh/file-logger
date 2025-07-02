//
//  BarsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request for historical data on an instrument (aggregated candlesticks).
public struct BarsRequest: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Desired timeframe for bars.
	public let timeframe: TimeFrame

	/// Query interval.
	public let interval: GoogleInterval

	// MARK: - Init
	public init(
		symbol: String,
		timeframe: TimeFrame,
		interval: GoogleInterval
	) {
		self.symbol = symbol
		self.timeframe = timeframe
		self.interval = interval
	}
}
