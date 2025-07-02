//
//  AssetParamsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Requesting the trading parameters of the instrument.
public struct AssetParamsRequest: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Account identifier for parameter lookup.
	public let accountId: String

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case symbol
		case accountId = "account_id"
	}

	// MARK: - Init
	public init(symbol: String, accountId: String) {
		self.symbol = symbol
		self.accountId = accountId
	}
}
