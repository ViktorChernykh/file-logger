//
//  ClockResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Time on the server.
public struct ClockResponse: Codable, Sendable {
	// MARK: Properties

	/// Server timestamp in ISO8601 format.
	public let timestamp: GoogleTimestamp

	// MARK: - Init
	public init(timestamp: GoogleTimestamp) {
		self.timestamp = timestamp
	}
}
