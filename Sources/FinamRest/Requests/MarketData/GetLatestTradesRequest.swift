//
//  GetLatestTradesRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 15.06.2025.
//

import RequestModel

/// Getting a list of recent trades on an instrument.
public struct GetLatestTradesRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	// MARK: - Init
	public init(symbol: String, token: String) {
		path = "\(Constants.instruments)/\(symbol)/trades/latest"
		addHeaders(token: token)
	}
}
