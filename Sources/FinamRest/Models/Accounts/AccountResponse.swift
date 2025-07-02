//
//  AccountResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Response with information about a specific account.
public struct AccountResponse: Codable, Sendable {
	// MARK: Properties

	/// Identifier of the account.
	public let accountId: String

	/// Type of the account.
	public let type: String

	/// Status of the account.
	public let status: String

	/// Available funds plus value of open positions.
	public let equity: GoogleDecimal

	/// Unrealized profit.
	public let unrealizedProfit: GoogleDecimal

	/// Open and theoretical positions.
	public let positions: [Position]

	/// Available cash balances.
	public let cash: [GoogleMoney]

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case accountId = "account_id"
		case type
		case status
		case equity
		case unrealizedProfit = "unrealized_profit"
		case positions
		case cash
	}

	// MARK: - Init
	public init(
		accountId: String,
		type: String,
		status: String,
		equity: GoogleDecimal,
		unrealizedProfit: GoogleDecimal,
		positions: [Position],
		cash: [GoogleMoney]
	) {
		self.accountId = accountId
		self.type = type
		self.status = status
		self.equity = equity
		self.unrealizedProfit = unrealizedProfit
		self.positions = positions
		self.cash = cash
	}
}
