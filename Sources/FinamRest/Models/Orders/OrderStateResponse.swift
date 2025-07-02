//
//  OrderStateResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// State of order.
public struct OrderStateResponse: Codable, Sendable {
	// MARK: Properties

	/// Order ID.
	public let orderId: String

	/// Execution ID.
	public let execId: String

	/// Status of order.
	public let status: OrderStatus

	/// Order.
	public let order: Order

	/// Date and time of order submission.
	public let transactAt: GoogleTimestamp

	/// Date and time of acceptance of the order.
	public let acceptAt: GoogleTimestamp?

	/// Date and time of cancellation of the order.
	public let withdrawAt: GoogleTimestamp?

	// MARK: - CodingKeys
	enum CodingKeys: String, CodingKey, Sendable {
		case orderId = "order_id"
		case execId = "exec_id"
		case status
		case order
		case transactAt = "transact_at"
		case acceptAt = "accept_at"
		case withdrawAt = "withdraw_at"
	}

	// MARK: - Init
	public init(
		orderId: String,
		execId: String,
		status: OrderStatus,
		order: Order,
		transactAt: GoogleTimestamp,
		acceptAt: GoogleTimestamp?,
		withdrawAt: GoogleTimestamp?
	) {
		self.orderId = orderId
		self.execId = execId
		self.status = status
		self.order = order
		self.transactAt = transactAt
		self.acceptAt = acceptAt
		self.withdrawAt = withdrawAt
	}
}
