//
//  StopCondition.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// The condition for triggering a stop order.
public enum StopConditionType: Int, Codable, Sendable {
	/// The value is not specified.
	case unspecified = 0	// STOP_CONDITION_UNSPECIFIED

	/// The trigger price is higher than the current price.
	case lastUp		 = 1	// STOP_CONDITION_LAST_UP

	/// The trigger price is less than the current price.
	case lastDown	 = 2	// STOP_CONDITION_LAST_DOWN
}
