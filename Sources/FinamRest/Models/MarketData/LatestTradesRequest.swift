//
//  LatestTradesRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Requesting a list of recent trades on an instrument.
public struct LatestTradesRequest: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	// MARK: - Init
	public init(symbol: String) {
		self.symbol = symbol
	}
}
