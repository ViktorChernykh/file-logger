//
//  TokenDetailsRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request for token details.
public struct TokenDetailsRequest: Codable, Sendable {
	// MARK: Properties

	/// JWT token to inspect.
	public let token: String

	// MARK: - Init
	public init(token: String) {
		self.token = token
	}
}
