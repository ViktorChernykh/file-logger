//
//  GetLastQuoteRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 15.06.2025.
//

import RequestModel

/// Getting the latest quote on an instrument.
public struct GetLastQuoteRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	// MARK: - Init
	public init(symbol: String, token: String) {
		path = "\(Constants.instruments)/\(symbol)/quotes/latest"
		addHeaders(token: token)
	}
}
