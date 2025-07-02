//
//  Option.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Information about the option.
public struct Option: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Option type (CALL or PUT).
	public let type: OptionType

	/// Contract size (lots).
	public let contractSize: GoogleDecimal

	/// First trading day (YYYY-MM-DD).
	public let tradeFirstDay: GoogleDate

	/// Last trading day or expiration (YYYY-MM-DD).
	public let tradeLastDay: GoogleDate

	/// Strike price.
	public let strike: GoogleDecimal

	/// Option multiplier.
	public let multiplier: GoogleDecimal

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case symbol
		case type
		case contractSize  = "contract_size"
		case tradeFirstDay = "trade_first_day"
		case tradeLastDay  = "trade_last_day"
		case strike
		case multiplier
	}

	/// Option type.
	public enum OptionType: Int8, Codable, Sendable {
		case unspecified = 0
		case call		 = 1
		case put		 = 2
	}

	// MARK: - Init
	public init(
		symbol: String,
		type: OptionType,
		contractSize: GoogleDecimal,
		tradeFirstDay: GoogleDate,
		tradeLastDay: GoogleDate,
		strike: GoogleDecimal,
		multiplier: GoogleDecimal
	) {
		self.symbol = symbol
		self.type = type
		self.contractSize = contractSize
		self.tradeFirstDay = tradeFirstDay
		self.tradeLastDay = tradeLastDay
		self.strike = strike
		self.multiplier = multiplier
	}
}
