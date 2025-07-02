//
//  GetOptionsChainRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Get a chain of options for the underlying asset.
public struct GetOptionsChainRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	// MARK: - Init
	public init(underlyingSymbol: String, token: String) {
		path = "\(Constants.assets)/\(underlyingSymbol)/options"
		addHeaders(token: token)
	}
}
