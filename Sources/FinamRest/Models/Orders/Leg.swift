//
//  Leg.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Leg.
public struct Leg: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Quantity of the leg.
	public let quantity: GoogleDecimal

	/// Side of the leg (long or short).
	public let side: SideType

	// MARK: - Init
	public init(symbol: String, quantity: GoogleDecimal, side: SideType) {
		self.symbol = symbol
		self.quantity = quantity
		self.side = side
	}
}
