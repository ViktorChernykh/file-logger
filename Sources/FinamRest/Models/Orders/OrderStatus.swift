//
//  OrderStatus.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Status of order.
public enum OrderStatus: Int, Codable, Sendable {
	case unspecified		= 0		// ORDER_STATUS_UNSPECIFIED
	case new				= 1		// ORDER_STATUS_NEW
	case partiallyFilled	= 2		// ORDER_STATUS_PARTIALLY_FILLED
	case filled				= 3		// ORDER_STATUS_FILLED
	case doneForDay			= 4		// ORDER_STATUS_DONE_FOR_DAY
	case canceled			= 5		// ORDER_STATUS_CANCELED
	case replaced			= 6		// ORDER_STATUS_REPLACED
	case pendingCancel		= 7		// ORDER_STATUS_PENDING_CANCEL
	case rejected			= 9		// ORDER_STATUS_REJECTED
	case suspended			= 10	// ORDER_STATUS_SUSPENDED
	case pendingNew			= 11	// ORDER_STATUS_PENDING_NEW
	case expired			= 13	// ORDER_STATUS_EXPIRED
	case failed				= 16	// ORDER_STATUS_FAILED
	case forwarding			= 17	// ORDER_STATUS_FORWARDING
	case wait				= 18	// ORDER_STATUS_WAIT
	case deniedByBroker		= 19	// ORDER_STATUS_DENIED_BY_BROKER
	case rejectedByExchange	= 20	// ORDER_STATUS_REJECTED_BY_EXCHANGE
	case watching			= 21	// ORDER_STATUS_WATCHING
	case executed			= 22	// ORDER_STATUS_EXECUTED
	case disabled			= 23	// ORDER_STATUS_DISABLED
	case linkWait			= 24	// ORDER_STATUS_LINK_WAIT
	case slGuardTime		= 27	// ORDER_STATUS_SL_GUARD_TIME
	case slExecuted			= 28	// ORDER_STATUS_SL_EXECUTED
	case slForwarding		= 29	// ORDER_STATUS_SL_FORWARDING
	case tpGuardTime		= 30	// ORDER_STATUS_TP_GUARD_TIME
	case tpExecuted			= 31	// ORDER_STATUS_TP_EXECUTED
	case tpCorrection		= 32	// ORDER_STATUS_TP_CORRECTION
	case tpForwarding		= 33	// ORDER_STATUS_TP_FORWARDING
	case tpCorrGuardTime	= 34	// ORDER_STATUS_TP_CORR_GUARD_TIME
}
