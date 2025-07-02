//
//  Trade.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Transaction Information.
public struct Trade: Codable, Sendable {
	// MARK: Properties

	/// Trade identifier provided by exchange.
	public let tradeId: String

	/// Market participant identifier.
	public let mpid: String

	/// Timestamp of the trade.
	public let timestamp: GoogleTimestamp

	/// Trade price.
	public let price: GoogleDecimal

	/// Trade size.
	public let size: GoogleDecimal

	/// Side of the trade.
	public let side: SideType

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case tradeId = "trade_id"
		case mpid
		case timestamp
		case price
		case size
		case side
	}

	// MARK: - Init
	public init(
		tradeId: String,
		mpid: String,
		timestamp: GoogleTimestamp,
		price: GoogleDecimal,
		size: GoogleDecimal,
		side: SideType
	) {
		self.tradeId = tradeId
		self.mpid = mpid
		self.timestamp = timestamp
		self.price = price
		self.size = size
		self.side = side
	}
}
