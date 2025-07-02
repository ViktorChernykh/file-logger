//
//  Exchange.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Information about the exchange.
public struct Exchange: Codable, Sendable {
	// MARK: Properties

	/// Market identifier code (MIC).
	public let mic: String

	/// Name of the exchange.
	public let name: String

	// MARK: - Init
	public init(mic: String, name: String) {
		self.mic = mic
		self.name = name
	}
}
