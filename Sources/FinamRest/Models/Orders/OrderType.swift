//
//  OrderType.swift
//  finam-rest
//
//  Created by Victor Chernykh on 12.06.2025.
//

/// Type of order.
public enum OrderType: Int, Codable, Sendable {
	case unspecified = 0	// ORDER_TYPE_UNSPECIFIED
	case market		 = 1	// ORDER_TYPE_MARKET
	case limit		 = 2	// ORDER_TYPE_LIMIT
	case stop		 = 3	// ORDER_TYPE_STOP
	case stopLimit	 = 4	// ORDER_TYPE_STOP_LIMIT
	case multiLeg	 = 5	// ORDER_TYPE_MULTI_LEG
}
