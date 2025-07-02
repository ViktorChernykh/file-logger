//
//  MDPermission.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Market data permission info.
public struct MDPermission: Codable, Sendable {
	// MARK: Properties

	/// Level of quotes available.
	public let quoteLevel: QuoteLevel

	/// Data delay in minutes.
	public let delayMinutes: Int

	/// Exchange Identifier Code (MIC).
	public let mic: String

	/// Country code (ISO).
	public let country: String

	/// Continent code.
	public let continent: String

	/// Flag indicating access to worldwide data.
	public let worldwide: Bool

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case quoteLevel   = "quote_level"
		case delayMinutes = "delay_minutes"
		case mic
		case country
		case continent
		case worldwide
	}

	/// Quote level public enumeration.
	public enum QuoteLevel: Int, Codable, Sendable {
		/// Unspecified value.
		case unspecified		= 0	// QUOTE_LEVEL_UNSPECIFIED
		/// Last trade price only.
		case lastPrice			= 1	// QUOTE_LEVEL_LAST_PRICE
		/// Best bid and ask.
		case bestBidOffer		= 2	// QUOTE_LEVEL_BEST_BID_OFFER
		/// Aggregated depth of orderbook.
		case depthOfMarket		= 3	// QUOTE_LEVEL_DEPTH_OF_MARKET
		/// Full orderbook depth.
		case depthOfBook		= 4	// QUOTE_LEVEL_DEPTH_OF_BOOK
		/// Access forbidden.
		case accessForbidden	= 5	// QUOTE_LEVEL_ACCESS_FORBIDDEN
	}

	// MARK: - Init
	public init(
		quoteLevel: QuoteLevel,
		delayMinutes: Int,
		mic: String,
		country: String,
		continent: String,
		worldwide: Bool
	) {
		self.quoteLevel = quoteLevel
		self.delayMinutes = delayMinutes
		self.mic = mic
		self.country = country
		self.continent = continent
		self.worldwide = worldwide
	}
}
