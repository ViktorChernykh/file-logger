//
//  LatestTradesResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// List of recent transactions on the instrument.
public struct LatestTradesResponse: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// List of latest trades.
	public let trades: [Trade]

	// MARK: - Init
	public init(symbol: String, trades: [Trade]) {
		self.symbol = symbol
		self.trades = trades
	}
}
