//
//  TradesResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Response with trade history of an account.
public struct TradesResponse: Codable, Sendable {
	// MARK: Properties

	/// List of account trades.
	public let trades: [AccountTrade]

	// MARK: - Init
	public init(trades: [AccountTrade]) {
		self.trades = trades
	}
}
