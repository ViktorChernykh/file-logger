//
//  Metadata+extensions.swift
//  file-logger
//
//  Created by Victor Chernykh on 19.09.2025.
//

import Logging

/// conveniences for metadata.
public extension Logger.Metadata {

	/// Merge two metadata dictionaries without overwriting existing keys by default.
	///
	/// - Parameter other: Other metadata to merge.
	/// - Returns: Merged metadata.
	@inline(__always)
	func merging(_ other: Logger.Metadata) -> Logger.Metadata {
		if self.isEmpty {
			return other
		} else if other.isEmpty {
			return self
		}
		var merged: Logger.Metadata = self
		for (key, value) in other {
			merged[key] = value
		}
		return merged
	}
}
