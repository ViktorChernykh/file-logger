//
//  TokenDetailsResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Response with token details.
public struct TokenDetailsResponse: Codable, Sendable {
	// MARK: Properties

	/// Timestamp when the token was created.
	public let createdAt: GoogleTimestamp

	/// Timestamp when the token will expire.
	public let expiresAt: GoogleTimestamp

	/// Market data permissions associated with this token.
	public let mdPermissions: [MDPermission]

	/// List of associated account identifiers.
	public let accountIds: [String]

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case createdAt = "created_at"
		case expiresAt = "expires_at"
		case mdPermissions = "md_permissions"
		case accountIds = "account_ids"
	}

	// MARK: - Init
	public init(
		createdAt: GoogleTimestamp,
		expiresAt: GoogleTimestamp,
		mdPermissions: [MDPermission],
		accountIds: [String]
	) {
		self.createdAt = createdAt
		self.expiresAt = expiresAt
		self.mdPermissions = mdPermissions
		self.accountIds = accountIds
	}
}
