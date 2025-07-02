//
//  CancelOrderRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Cancellation of the exchange order.
public struct CancelOrderRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .DELETE
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
