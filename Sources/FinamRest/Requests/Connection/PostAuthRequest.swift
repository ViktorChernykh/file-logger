//
//  PostAuthTokenRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting a JWT token from the Token API.
public struct PostAuthTokenRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .POST
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]
	public let body: Codable?

	// MARK: - Init
	public init(dto: AuthRequest) {
		path = Constants.sessions
		body = dto
		addHeaders(token: nil)
	}
}
