//
//  OrdersResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// List of trading orders.
public struct OrdersResponse: Codable, Sendable {
	// MARK: Properties
	
	/// List of order states.
	public let orders: [OrderStateResponse]

	// MARK: - Init
	public init(orders: [OrderStateResponse]) {
		self.orders = orders
	}
}
