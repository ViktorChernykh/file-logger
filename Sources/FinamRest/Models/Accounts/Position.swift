//
//  Position.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Position information (open and theoretical).
public struct Position: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Quantity, signed (positive = long, negative = short).
	public let quantity: GoogleDecimal

	/// Average price of the position.
	public let averagePrice: GoogleDecimal

	/// Current market price of the instrument.
	public let currentPrice: GoogleDecimal

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case symbol
		case quantity
		case averagePrice = "average_price"
		case currentPrice = "current_price"
	}

	// MARK: - Init
	public init(
		symbol: String,
		quantity: GoogleDecimal,
		averagePrice: GoogleDecimal,
		currentPrice: GoogleDecimal
	) {
		self.symbol = symbol
		self.quantity = quantity
		self.averagePrice = averagePrice
		self.currentPrice = currentPrice
	}
}
