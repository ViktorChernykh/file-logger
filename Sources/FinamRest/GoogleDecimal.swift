//
//  GoogleDecimal.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

import struct Foundation.Decimal

/// `google.type.Decimal`
public struct GoogleDecimal: Codable, Sendable {
	// MARK: Properties

	/// Decimal value represented as a string.
	public let value: String

	// MARK: - Init
	public init(value: String) {
		self.value = value
	}

	public init(value: Decimal) {
		self.value = "\(value)"
	}
}
