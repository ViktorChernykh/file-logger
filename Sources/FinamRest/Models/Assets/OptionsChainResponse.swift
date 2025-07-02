//
//  OptionsChainResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Information about the options chain.
public struct OptionsChainResponse: Codable, Sendable {
	// MARK: Properties

	/// Underlying symbol for the options chain.
	public let symbol: String

	/// List of options for the underlying symbol.
	public let options: [Option]

	// MARK: - Init
	public init(symbol: String, options: [Option]) {
		self.symbol = symbol
		self.options = options
	}
}
