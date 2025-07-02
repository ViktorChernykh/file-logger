//
//  AuthRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request for obtaining JWT token.
public struct AuthRequest: Codable, Sendable {
	// MARK: Properties

	/// API secret key provided by Finam.
	public let secret: String

	// MARK: - Init
	public init(secret: String) {
		self.secret = secret
	}
}
