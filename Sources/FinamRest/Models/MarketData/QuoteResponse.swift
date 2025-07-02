//
//  QuoteResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// The latest quote on the instrument.
public struct QuoteResponse: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Latest quote.
	public let quote: Quote

	// MARK: - Init
	public init(symbol: String, quote: Quote) {
		self.symbol = symbol
		self.quote = quote
	}
}
