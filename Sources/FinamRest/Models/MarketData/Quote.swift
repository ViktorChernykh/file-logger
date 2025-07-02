//
//  Quote.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Quotation Information.
public struct Quote: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Timestamp of the quote.
	public let timestamp: GoogleTimestamp

	/// Ask price (0 if none).
	public let ask: GoogleDecimal

	/// Ask size.
	public let askSize: GoogleDecimal

	/// Bid price (0 if none).
	public let bid: GoogleDecimal

	/// Bid size.
	public let bidSize: GoogleDecimal

	/// Last trade price.
	public let last: GoogleDecimal

	/// Last trade size.
	public let lastSize: GoogleDecimal

	/// Daily volume.
	public let volume: GoogleDecimal

	/// Daily turnover.
	public let turnover: GoogleDecimal

	/// Day open price.
	public let open: GoogleDecimal

	/// Day high price.
	public let high: GoogleDecimal

	/// Day low price.
	public let low: GoogleDecimal

	/// Day close price.
	public let close: GoogleDecimal

	/// Price change (last minus close).
	public let change: GoogleDecimal

	/// Option-specific data.
	public let option: OptionData?

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case symbol
		case timestamp
		case ask
		case askSize = "ask_size"
		case bid
		case bidSize = "bid_size"
		case last
		case lastSize = "last_size"
		case volume
		case turnover
		case open
		case high
		case low
		case close
		case change
		case option
	}

	/// Information about the option.
	public struct OptionData: Codable, Sendable {
		/// Open interest.
		public let openInterest: GoogleDecimal

		/// Implied volatility.
		public let impliedVolatility: GoogleDecimal

		/// Theoretical price.
		public let theoreticalPrice: GoogleDecimal

		/// Delta Greek.
		public let delta: GoogleDecimal

		/// Gamma Greek.
		public let gamma: GoogleDecimal

		/// Theta Greek.
		public let theta: GoogleDecimal

		/// Vega Greek.
		public let vega: GoogleDecimal

		/// Rho Greek.
		public let rho: GoogleDecimal

		// MARK: - CodingKeys
		public enum CodingKeys: String, CodingKey, Sendable {
			case openInterest = "open_interest"
			case impliedVolatility = "implied_volatility"
			case theoreticalPrice = "theoretical_price"
			case delta
			case gamma
			case theta
			case vega
			case rho
		}

		// MARK: - Init
		public init(
			openInterest: GoogleDecimal,
			impliedVolatility: GoogleDecimal,
			theoreticalPrice: GoogleDecimal,
			delta: GoogleDecimal,
			gamma: GoogleDecimal,
			theta: GoogleDecimal,
			vega: GoogleDecimal,
			rho: GoogleDecimal
		) {
			self.openInterest = openInterest
			self.impliedVolatility = impliedVolatility
			self.theoreticalPrice = theoreticalPrice
			self.delta = delta
			self.gamma = gamma
			self.theta = theta
			self.vega = vega
			self.rho = rho
		}
	}

	// MARK: - Init
	public init(
		symbol: String,
		timestamp: GoogleTimestamp,
		ask: GoogleDecimal,
		askSize: GoogleDecimal,
		bid: GoogleDecimal,
		bidSize: GoogleDecimal,
		last: GoogleDecimal,
		lastSize: GoogleDecimal,
		volume: GoogleDecimal,
		turnover: GoogleDecimal,
		open: GoogleDecimal,
		high: GoogleDecimal,
		low: GoogleDecimal,
		close: GoogleDecimal,
		change: GoogleDecimal,
		option: OptionData?
	) {
		self.symbol = symbol
		self.timestamp = timestamp
		self.ask = ask
		self.askSize = askSize
		self.bid = bid
		self.bidSize = bidSize
		self.last = last
		self.lastSize = lastSize
		self.volume = volume
		self.turnover = turnover
		self.open = open
		self.high = high
		self.low = low
		self.close = close
		self.change = change
		self.option = option
	}
}
