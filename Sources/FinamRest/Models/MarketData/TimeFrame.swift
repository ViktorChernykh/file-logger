//
//  TimeFrame.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Available timeframes for candles.
public enum TimeFrame: Int, Codable, Sendable {
	case unspecified = 0
	case m1			= 1
	case m5			= 5
	case m15		= 9
	case m30		= 11
	case h1			= 12
	case h2			= 13
	case h4			= 15
	case h8			= 17
	case d			= 19
	case w			= 20
	case mn			= 21
	case qr			= 22
}
