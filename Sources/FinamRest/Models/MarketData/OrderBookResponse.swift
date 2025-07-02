//
//  OrderBookResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// The current OrderBook for instrument.
public struct OrderBookResponse: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Current order book.
	public let orderbook: OrderBook

	// MARK: - Init
	public init(symbol: String, orderbook: OrderBook) {
		self.symbol = symbol
		self.orderbook = orderbook
	}
}
