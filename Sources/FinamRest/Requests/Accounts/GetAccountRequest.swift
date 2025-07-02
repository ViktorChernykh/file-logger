//
//  GetAccountRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting information about a specific account.
public struct GetAccountRequest: RequestProtocol {

	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	public let repeatIfBadResponse: UInt8 = 2

	// MARK: - Init
	public init(accountId: String, token: String) {
		path = "\(Constants.accounts)/\(accountId)"
		addHeaders(token: token)
	}
}
