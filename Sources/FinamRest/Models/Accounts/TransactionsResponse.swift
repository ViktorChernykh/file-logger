//
//  TransactionsResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Response with transaction list of an account.
public struct TransactionsResponse: Codable, Sendable {
	// MARK: Properties

	/// List of account transactions.
	public let transactions: [Transaction]

	// MARK: - Init
	public init(transactions: [Transaction]) {
		self.transactions = transactions
	}
}
