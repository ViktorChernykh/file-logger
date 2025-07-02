//
//  Order.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

import struct Foundation.Decimal

/// Information about the order.
public struct Order: Codable, Sendable {
	// MARK: Properties

	/// Account ID.
	public let accountId: String

	/// The symbol of the instrument.
	public let symbol: String

	/// Quantity in pcs.
	public let quantity: GoogleDecimal

	/// Side (long or short).
	public let side: SideType

	/// Order type.
	public let type: OrderType

	/// The validity period of the order.
	public let timeInForce: TimeInForce

	/// Required for limit and stop limit orders.
	public let limitPrice: GoogleDecimal?

	/// Required for stop market and stop limit orders.
	public let stopPrice: GoogleDecimal?

	/// Required for stop market and stop limit orders.
	public let stopCondition: StopConditionType?

	/// Required for multi-leg order.
	public let legs: [Leg]?

	/// The unique identifier of the application. Automatically generated if not sent. (maximum of 20 characters).
	public let clientOrderId: String?

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case accountId = "account_id"
		case symbol
		case quantity
		case side
		case type
		case timeInForce = "time_in_force"
		case limitPrice = "limit_price"
		case stopPrice = "stop_price"
		case stopCondition = "stop_condition"
		case legs
		case clientOrderId = "client_order_id"
	}

	// MARK: - Init
	public init(
		accountId: String,
		symbol: String,
		quantity: GoogleDecimal,
		side: SideType,
		type: OrderType,
		timeInForce: TimeInForce,
		limitPrice: GoogleDecimal?,
		stopPrice: GoogleDecimal?,
		stopCondition: StopConditionType?,
		legs: [Leg]?,
		clientOrderId: String?
	) {
		self.accountId = accountId
		self.symbol = symbol
		self.quantity = quantity
		self.side = side
		self.type = type
		self.timeInForce = timeInForce
		self.limitPrice = limitPrice
		self.stopPrice = stopPrice
		self.stopCondition = stopCondition
		self.legs = legs
		self.clientOrderId = clientOrderId
	}

	public init(
		accountId: String,
		symbol: String,
		quantity: Decimal,
		side: SideType,
		type: OrderType,
		timeInForce: TimeInForce,
		limitPrice: Decimal?,
		stopPrice: Decimal?,
		stopCondition: StopConditionType?,
		legs: [Leg]?,
		clientOrderId: String?
	) {
		self.accountId = accountId
		self.symbol = symbol
		self.quantity = GoogleDecimal(value: quantity)
		self.side = side
		self.type = type
		self.timeInForce = timeInForce
		self.limitPrice = limitPrice == nil ? nil : GoogleDecimal(value: limitPrice!)
		self.stopPrice = stopPrice == nil ? nil : GoogleDecimal(value: stopPrice!)
		self.stopCondition = stopCondition
		self.legs = legs
		self.clientOrderId = clientOrderId
	}
}
