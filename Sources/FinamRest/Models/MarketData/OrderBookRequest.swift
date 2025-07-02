//
//  OrderBookRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request to get the current glass for the instrument.
public struct OrderBookRequest: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	// MARK: - Init
	public init(symbol: String) {
		self.symbol = symbol
	}
}
