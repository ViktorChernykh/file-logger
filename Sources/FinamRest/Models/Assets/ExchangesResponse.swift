//
//  ExchangesResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// List of available exchanges.
public struct ExchangesResponse: Codable, Sendable {
	// MARK: Properties

	/// List of available exchanges.
	public let exchanges: [Exchange]

	// MARK: - Init
	public init(exchanges: [Exchange]) {
		self.exchanges = exchanges
	}
}
