//
//  OrderBook.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Information about the OrderBook.
public struct OrderBook: Codable, Sendable {
	// MARK: Properties

	/// Order book levels.
	public let rows: [Row]

	/// Information about the level in the glass (row).
	public struct Row: Codable, Sendable {
		/// Price level.
		public let price: GoogleDecimal

		/// Sell size at level.
		public let sellSize: GoogleDecimal

		/// Buy size at level.
		public let buySize: GoogleDecimal

		/// Action for the level.
		public let action: Action

		/// Market participant identifier.
		public let mpid: String

		/// Timestamp of the update.
		public let timestamp: GoogleTimestamp

		// MARK: - CodingKeys
		public enum CodingKeys: String, CodingKey, Sendable {
			case price
			case sellSize = "sell_size"
			case buySize  = "buy_size"
			case action
			case mpid
			case timestamp
		}

		/// Action for the level.
		public enum Action: Int, Codable, Sendable {
			case unspecified = 0
			case remove		 = 1
			case add		 = 2
			case update		 = 3
		}

		// MARK: - Init
		public init(
			price: GoogleDecimal,
			sellSize: GoogleDecimal,
			buySize: GoogleDecimal,
			action: Action,
			mpid: String,
			timestamp: GoogleTimestamp
		) {
			self.price = price
			self.sellSize = sellSize
			self.buySize = buySize
			self.action = action
			self.mpid = mpid
			self.timestamp = timestamp
		}
	}

	// MARK: - Init
	public init(rows: [Row]) {
		self.rows = rows
	}
}
