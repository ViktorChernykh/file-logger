//
//  PlaceOrderRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 15.06.2025.
//

import RequestModel

/// Submitting an exchange order.
public struct PlaceOrderRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .POST
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String] = [:]
	public let body: Codable?

	// MARK: - Init
	public init(order: Order, token: String) {
		path = "\(Constants.accounts)/\(order.accountId)/orders"
		self.body = order
		addHeaders(token: token)
	}
}
