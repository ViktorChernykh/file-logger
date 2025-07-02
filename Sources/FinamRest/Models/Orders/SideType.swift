//
//  Side.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Direction of trade.
public enum SideType: Int, Codable, Sendable {

	/// The side of the transaction is not specified.
	case unspecified = 0	// SIDE_UNSPECIFIED

	/// Long position side.
	case buy = 1			// SIDE_BUY

	/// Short position side.
	case sell = 2			// SIDE_SELL
}
