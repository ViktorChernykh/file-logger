//
//  Longable.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Are Long-term transactions available?
public struct Longable: Codable, Sendable {
	// MARK: Properties

	/// Status of long operations.
	public let value: Status

	/// Number of days long operations are halted.
	public let haltedDays: Int

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case value
		case haltedDays = "halted_days"
	}

	/// Status of long operations.
	public enum Status: Int8, Codable, Sendable {
		case notAvailable		= 0
		case available			= 1
		case accountNotApproved = 2
	}

	// MARK: - Init
	public init(value: Status, haltedDays: Int) {
		self.value = value
		self.haltedDays = haltedDays
	}
}
