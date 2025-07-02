//
//  AuthResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Response from auth service.
public struct AuthResponse: Codable, Sendable {
	// MARK: Properties

	/// JWT token for authenticated requests.
	public let token: String

	// MARK: - Init
	public init(token: String) {
		self.token = token
	}
}
