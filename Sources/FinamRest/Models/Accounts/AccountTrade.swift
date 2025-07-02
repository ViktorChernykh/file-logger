//
//  AccountTrade.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Stub for AccountTrade; define fields according to grpc.tradeapi.v1.AccountTrade spec.
public struct AccountTrade: Codable, Sendable {
	// MARK: Properties

	// Transaction ID
	public let tradeId: String

	// Tool symbol
	public let symbol: String

	// Execution price
	public let price: GoogleDecimal

	// Size in pcs.
	public let size: GoogleDecimal

	// Side of the deal (long or short)
	public let side: SideType

	// Timestamp
	public let timestamp: GoogleTimestamp

	// Request ID
	public let orderId: String

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case tradeId = "trade_id"
		case symbol
		case price
		case size
		case side
		case timestamp
		case orderId = "order_id"
	}

	// MARK: - Init
	public init(
		tradeId: String,
		symbol: String,
		price: GoogleDecimal,
		size: GoogleDecimal,
		side: SideType,
		timestamp: GoogleTimestamp,
		orderId: String
	) {
		self.tradeId = tradeId
		self.symbol = symbol
		self.price = price
		self.size = size
		self.side = side
		self.timestamp = timestamp
		self.orderId = orderId
	}
}
