//
//  AssetParamsResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Trading parameters of the instrument.
public struct AssetParamsResponse: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Account identifier for parameter lookup.
	public let accountId: String

	/// Flag indicating if trading operations are permitted.
	public let tradeable: Bool

	/// Long position availability.
	public let longable: Longable

	/// Short position availability.
	public let shortable: Shortable

	/// Risk rate for long positions.
	public let longRiskRate: GoogleDecimal

	/// Collateral amount required for long positions.
	public let longCollateral: GoogleMoney

	/// Risk rate for short positions.
	public let shortRiskRate: GoogleDecimal

	/// Collateral amount required for short positions.
	public let shortCollateral: GoogleMoney

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case symbol
		case accountId       = "account_id"
		case tradeable
		case longable
		case shortable
		case longRiskRate    = "long_risk_rate"
		case longCollateral  = "long_collateral"
		case shortRiskRate   = "short_risk_rate"
		case shortCollateral = "short_collateral"
	}

	// MARK: - Init
	public init(
		symbol: String,
		accountId: String,
		tradeable: Bool,
		longable: Longable,
		shortable: Shortable,
		longRiskRate: GoogleDecimal,
		longCollateral: GoogleMoney,
		shortRiskRate: GoogleDecimal,
		shortCollateral: GoogleMoney
	) {
		self.symbol = symbol
		self.accountId = accountId
		self.tradeable = tradeable
		self.longable = longable
		self.shortable = shortable
		self.longRiskRate = longRiskRate
		self.longCollateral = longCollateral
		self.shortRiskRate = shortRiskRate
		self.shortCollateral = shortCollateral
	}
}
