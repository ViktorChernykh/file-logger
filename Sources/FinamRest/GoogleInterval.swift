//
//  GoogleInterval.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// `google.type.Interval`
public struct GoogleInterval: Codable, Sendable {
	// MARK: Properties

	/// Start of the interval (seconds since epoch).
	public let start: GoogleTimestamp

	/// End of the interval (seconds since epoch).
	public let end: GoogleTimestamp

	// MARK: - Init
	public init(start: GoogleTimestamp, end: GoogleTimestamp) {
		self.start = start
		self.end = end
	}


}
