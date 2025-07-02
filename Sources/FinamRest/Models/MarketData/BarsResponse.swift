//
//  BarsResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// List of aggregated candlesticks.
public struct BarsResponse: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Aggregated bars.
	public let bars: [Bar]

	// MARK: - Init
	public init(symbol: String, bars: [Bar]) {
		self.symbol = symbol
		self.bars = bars
	}
}
