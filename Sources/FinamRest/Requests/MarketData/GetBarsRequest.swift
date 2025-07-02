//
//  GetBarsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 15.06.2025.
//

import RequestModel

/// Getting historical data on an instrument (aggregated candlesticks).
public struct GetBarsRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String]

	// MARK: - Init
	public init(
		symbol: String,
		timeframe: TimeFrame,
		interval: GoogleInterval,
		token: String
	) {
		path = "\(Constants.instruments)/\(symbol)/bars"
		queries = [
			"timeframe": "\(timeframe.rawValue)",
			"interval.start_time": interval.start.dateFormat,
			"interval.end_time": interval.end.dateFormat
		]
		addHeaders(token: token)
	}
}
