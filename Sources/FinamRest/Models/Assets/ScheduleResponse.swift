//
//  ScheduleResponse.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Schedule if Instrument.
public struct ScheduleResponse: Codable, Sendable {
	// MARK: Properties

	/// Instrument symbol.
	public let symbol: String

	/// Trading sessions for the instrument.
	public let sessions: [Sessions]

	/// Trading sessions for the instrument.
	public struct Sessions: Codable, Sendable {
		/// Session type.
		public let type: String

		/// Time interval of the session.
		public let interval: GoogleInterval

		// MARK: - Init
		public init(type: String, interval: GoogleInterval) {
			self.type = type
			self.interval = interval
		}
	}

	// MARK: - Init
	public init(symbol: String, sessions: [Sessions]) {
		self.symbol = symbol
		self.sessions = sessions
	}
}
