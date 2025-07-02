//
//  TradesRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request for retrieving trade history of an account.
public struct TradesRequest: Codable, Sendable {
	// MARK: Properties

	/// Identifier of the account.
	public let accountId: String

	/// Maximum number of trades to return.
	public let limit: Int

	/// Period interval for the query.
	public let interval: GoogleInterval

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case accountId = "account_id"
		case limit
		case interval
	}

	// MARK: - Init
	public init(
		accountId: String,
		limit: Int,
		interval: GoogleInterval
	) {
		self.accountId = accountId
		self.limit = limit
		self.interval = interval
	}
}
