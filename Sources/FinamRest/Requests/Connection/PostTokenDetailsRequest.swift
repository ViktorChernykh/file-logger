//
//  PostTokenDetailsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting information about the session token.
public struct PostTokenDetailsRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .POST
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]
	public let body: Codable?

	// MARK: - Init
	public init(dto: TokenDetailsRequest, token: String) {
		path = "\(Constants.sessions)/details"
		body = dto
		addHeaders(token: token)
	}
}
