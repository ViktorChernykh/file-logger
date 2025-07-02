//
//  OptionsChainRequest.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Request to receive a chain of options.
public struct OptionsChainRequest: Codable, Sendable {
	// MARK: Properties

	/// Underlying asset symbol.
	public let underlyingSymbol: String

	// MARK: - CodingKeys
	public enum CodingKeys: String, CodingKey, Sendable {
		case underlyingSymbol = "underlying_symbol"
	}

	// MARK: - Init
	public init(underlyingSymbol: String) {
		self.underlyingSymbol = underlyingSymbol
	}
}
