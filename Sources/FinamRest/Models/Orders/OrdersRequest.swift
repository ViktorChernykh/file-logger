//
//  OrdersRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request to receive a list of trading orders.
public struct OrdersRequest: Codable, Sendable {
	// MARK: Properties
	
	/// Identifier of the account.
	public let accountId: String

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case accountId = "account_id"
	}

	// MARK: - Init
	public init(accountId: String) {
		self.accountId = accountId
	}
}
