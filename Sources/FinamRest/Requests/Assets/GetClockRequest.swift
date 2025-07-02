//
//  GetClockRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting the time on the server.
public struct GetClockRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	// MARK: - Init
	public init(token: String) {
		path = "\(Constants.assets)/clock"
		addHeaders(token: token)
	}
}
