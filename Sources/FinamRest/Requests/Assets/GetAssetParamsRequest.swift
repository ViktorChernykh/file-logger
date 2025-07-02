//
//  GetAssetParamsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting trading parameters for an instrument.
public struct GetAssetParamsRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String]

	// MARK: - Init
	public init(accountId: String, symbol: String, token: String) {
		path = "\(Constants.assets)/\(symbol)/params"
		queries = [
			"account_id": accountId
		]
		addHeaders(token: token)
	}
}
