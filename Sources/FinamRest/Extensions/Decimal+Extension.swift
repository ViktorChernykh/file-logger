//
//  Decimal+Extension.swift
//  finam-rest
//
//  Created by Victor Chernykh on 22.06.2025.
//

import Foundation

public extension Decimal {

	/// Splits a Decimal into integer and fractional parts **without** strings,
	/// automatically detecting scale by multiplying until the value is integral.
	/// - Returns: `(integer, fraction, scale)` – all `Int`.
	@inline(__always)
	var splitDynamic: (integer: Int, fraction: Int, scale: Int) {

		// 1. Iteratively shift decimal point right until remainder disappears
		var working: Decimal = self
		var scale: Int = 0
		var shiftedInt: Int = 0

		repeat {
			scale &+= 1
			working *= 10                          // move dot one digit right
			shiftedInt = Int(NSDecimalNumber(decimal: working).intValue)
		} while working != Decimal(shiftedInt)     // repeat while still fractional

		// 2. After loop: working is integral == shiftedInt
		let multiplier: Int = Int(pow(10.0, Double(scale)))
		let integerPart: Int = shiftedInt / multiplier
		let fractionPart: Int = abs(shiftedInt % multiplier)

		return (integerPart, fractionPart, scale)
	}
}
