//
//  Transaction.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Transaction information within an account.
public struct Transaction: Codable, Sendable {
	// MARK: Properties

	/// Transaction identifier.
	public let id: String

	/// Category of the transaction.
	public let category: String

	/// Timestamp of the transaction.
	public let timestamp: GoogleTimestamp

	/// Instrument symbol.
	public let symbol: String

	/// Change in funds.
	public let change: GoogleMoney

	/// Trade details for trading transactions.
	public let trade: Transaction.Trade?

	/// Nested trade details for trading-type transactions.
	public struct Trade: Codable, Sendable {
		/// Quantity traded.
		public let size: GoogleDecimal

		/// Execution price per unit.
		public let price: GoogleDecimal

		/// Accrued interest, if applicable.
		public let accruedInterest: GoogleDecimal?

		// MARK: - CodingKeys
		public enum CodingKeys: String, CodingKey, Sendable {
			case size
			case price
			case accruedInterest = "accrued_interest"
		}

		// MARK: - Init
		public init(
			size: GoogleDecimal,
			price: GoogleDecimal,
			accruedInterest: GoogleDecimal?
		) {
			self.size = size
			self.price = price
			self.accruedInterest = accruedInterest
		}
	}

	// MARK: - Init
	public init(
		id: String,
		category: String,
		timestamp: GoogleTimestamp,
		symbol: String,
		change: GoogleMoney,
		trade: Transaction.Trade?
	) {
		self.id = id
		self.category = category
		self.timestamp = timestamp
		self.symbol = symbol
		self.change = change
		self.trade = trade
	}
}
