//
//  GoogleMoney.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

import Foundation

/// `google.type.Money`.
public struct GoogleMoney: Codable, Sendable {
	// MARK: Properties

	/// Major units of currency.
	public let units: Int

	/// Nanoseconds fraction.
	public let nanos: Int

	/// The three-letter currency code defined in ISO 4217.
	public let currencyCode: String

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case units
		case nanos
		case currencyCode = "currency_code"
	}

	// MARK: - Init
	public init(units: Int, nanos: Int, currencyCode: String) {
		self.units = units
		self.nanos = nanos
		self.currencyCode = currencyCode
	}

	public init(value: Decimal, currencyCode: String) {
		let (units, nanos, _) = value.splitDynamic
		self.units = units
		self.nanos = nanos
		self.currencyCode = currencyCode
	}
}
