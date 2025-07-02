//
//  TimeInForce.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// The validity period of the order.
public enum TimeInForce: Int, Codable, Sendable {
	case unspecified		= 0		// TIME_IN_FORCE_UNSPECIFIED
	case day				= 1		// TIME_IN_FORCE_DAY
	case goodTillCancel		= 2		// TIME_IN_FORCE_GOOD_TILL_CANCEL
	case goodTillCrossing	= 3		// TIME_IN_FORCE_GOOD_TILL_CROSSING
	case extendedHours		= 4		// TIME_IN_FORCE_EXT
	case onOpen				= 5		// TIME_IN_FORCE_ON_OPEN
	case onClose			= 6		// TIME_IN_FORCE_ON_CLOSE
	case immediateOrCancel	= 7		// TIME_IN_FORCE_IOC
	case fillOrKill			= 8		// TIME_IN_FORCE_FOK
}
