//
//  GoogleDate.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// `google.type.Date`
public struct GoogleDate: Codable, Sendable {
	// MARK: Properties

	/// Year of the date. Must be from 1 to 9999.
	public let year: Int

	/// Month of a year. Must be from 1 to 12.
	public let month: Int

	/// Day of a month. Must be from 1 to 31 and valid for the year and month.
	public let day: Int

	// MARK: - Init
	public init(year: Int, month: Int, day: Int) {
		self.year = year
		self.month = month
		self.day = day
	}
}
