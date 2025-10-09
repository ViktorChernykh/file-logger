//
//  Logger+extensions.swift
//  file-logger
//
//  Created by Victor Chernykh on 19.09.2025.
//

import Logging

/// Logger conveniences for metadata.
public extension Logger {
	/// Merge a metadata dictionary into this logger in-place.
	@inline(__always)
	mutating func mergeMetadata(_ additional: Logger.Metadata) {
		if additional.isEmpty { return }
		for (key, value) in additional {
			self[metadataKey: key] = value
		}
	}

	/// Return a copy of this logger with additional metadata.
	@inline(__always)
	func with(metadata additional: Logger.Metadata) -> Logger {
		var copy: Logger = self
		copy.mergeMetadata(additional)
		return copy
	}
}
