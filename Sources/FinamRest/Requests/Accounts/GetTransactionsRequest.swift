//
//  GetTransactionsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import RequestModel

/// Getting a list of account transactions.
public struct GetTransactionsRequest: RequestProtocol {
	public let path: String

	public let requestType: RequestMethod = .GET
	public let contentType: ContentType = .json
	public let cachePolicy: CachePolicy = .useNoStoreNoCache

	public var headers: [(String, String)] = .init()
	public let queries: [String: String]

	// MARK: - Init
	public init(accountId: String, limit: Int = 50, interval: GoogleInterval, token: String) {
		path = "\(Constants.accounts)/\(accountId)/transactions"
		queries = [
			"limit": "\(limit)",
			"interval.start_time": interval.start.dateFormat,
			"interval.end_time": interval.end.dateFormat
		]
		addHeaders(token: token)
	}
}
