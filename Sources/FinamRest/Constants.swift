//
//  Constants.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

import class Foundation.DateFormatter
import struct Foundation.Locale
import struct Foundation.TimeZone

public enum Constants {
	static let domain: String = "https://api.finam.ru"

	// Connection
	static let sessions: String = "\(Self.domain)/v1/sessions"

	// Accounts, Orders
	static let accounts: String = "\(Self.domain)/v1/accounts"

	// Assets
	static let assets: String = "\(Self.domain)/v1/assets"
	static let exchanges: String = "\(Self.domain)/v1/exchanges"

	// MarketData
	static let instruments: String = "\(Self.domain)/v1/instruments"

	@inline(__always)
	public static let finamDateFormatter: DateFormatter = {
		let formatter: DateFormatter = .init()
		// Formatting is independent of user settings thanks to "en_US_POSIX"
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(identifier: "Europe/Moscow")!
		formatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
		return formatter
	}()
}
