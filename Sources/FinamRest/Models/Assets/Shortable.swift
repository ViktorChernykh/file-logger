//
//  Shortable.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Are operations available in Short.
public struct Shortable: Codable, Sendable {
	// MARK: Properties

	/// Status of short operations.
	public let value: Status

	/// Number of days short operations are halted.
	public let haltedDays: Int

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case value
		case haltedDays = "halted_days"
	}

	/// Status of short operations.
	public enum Status: Int8, Codable, Sendable {
		case notAvailable		= 0
		case available			= 1
		case htb				= 2
		case accountNotApproved = 3
		case availableStrategy	= 4
	}

	// MARK: - Init
	init(value: Status, haltedDays: Int) {
		self.value = value
		self.haltedDays = haltedDays
	}
}
