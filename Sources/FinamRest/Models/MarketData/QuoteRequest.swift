//
//  QuoteRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request to receive the latest quote on an instrument.
public struct QuoteRequest: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	// MARK: - Init
	public init(symbol: String) {
		self.symbol = symbol
	}
}
