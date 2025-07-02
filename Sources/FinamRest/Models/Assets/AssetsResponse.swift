//
//  AssetsResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// List of available Instruments.
public struct AssetsResponse: Codable, Sendable {
	// MARK: Properties

	/// List of available instruments.
	public let assets: [Asset]

	// MARK: - Init
	public init(assets: [Asset]) {
		self.assets = assets
	}
}
