//
//  AssetResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// A list of information about a specific Instrument.
public struct AssetResponse: Codable, Sendable {
	// MARK: Properties

	/// Trading board code.
	public let board: String

	/// Instrument identifier.
	public let id: String

	/// Instrument ticker.
	public let ticker: String

	/// Market identifier code (MIC).
	public let mic: String

	/// ISIN identifier.
	public let isin: String

	/// Type of the instrument.
	public let type: String

	/// Name of the instrument.
	public let name: String

	/// Number of decimal places in price.
	public let decimals: Int

	/// Minimum price increment.
	public let minStep: Int

	/// Lot size quantity.
	public let lotSize: GoogleDecimal

	/// Futures expiration date in YYYY-MM-DD.
	public let expirationDate: GoogleDate?

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case board
		case id
		case ticker
		case mic
		case isin
		case type
		case name
		case decimals
		case minStep = "min_step"
		case lotSize = "lot_size"
		case expirationDate = "expiration_date"
	}

	// MARK: - Init
	public init(
		board: String,
		id: String,
		ticker: String,
		mic: String,
		isin: String,
		type: String,
		name: String,
		decimals: Int,
		minStep: Int,
		lotSize: GoogleDecimal,
		expirationDate: GoogleDate?
	) {
		self.board = board
		self.id = id
		self.ticker = ticker
		self.mic = mic
		self.isin = isin
		self.type = type
		self.name = name
		self.decimals = decimals
		self.minStep = minStep
		self.lotSize = lotSize
		self.expirationDate = expirationDate
	}
}
