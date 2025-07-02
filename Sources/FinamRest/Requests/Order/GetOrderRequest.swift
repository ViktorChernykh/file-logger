//
//  GetOrderRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 15.06.2025.
//

import RequestModel

/// Getting information about a specific order.
public struct GetOrderRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]

	// MARK: - Init
	public init(accountId: String, orderId: String, token: String) {
		path = "\(Constants.accounts)/\(accountId)/orders/\(orderId)"
		addHeaders(token: token)
	}
}
