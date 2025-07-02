//
//  Assets.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Information about the Instrument.
public struct Asset: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol in format ticker@mic.
	public let symbol: String

	/// Unique identifier of the instrument.
	public let id: String

	/// Ticker of the instrument.
	public let ticker: String

	/// Market identifier code (MIC).
	public let mic: String

	/// ISIN identifier of the instrument.
	public let isin: String

	/// Type of the instrument.
	public let type: String

	/// Name of the instrument.
	public let name: String

	// MARK: - Init
	public init(
		symbol: String,
		id: String,
		ticker: String,
		mic: String,
		isin: String,
		type: String,
		name: String
	) {
		self.symbol = symbol
		self.id = id
		self.ticker = ticker
		self.mic = mic
		self.isin = isin
		self.type = type
		self.name = name
	}
}
