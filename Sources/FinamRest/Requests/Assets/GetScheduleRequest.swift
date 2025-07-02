//
//  GetScheduleRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting a trading schedule for an instrument.
public struct GetScheduleRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	// MARK: - Init
	public init(symbol: String, token: String) {
		path = "\(Constants.assets)/\(symbol)/schedule"
		addHeaders(token: token)
	}
}
