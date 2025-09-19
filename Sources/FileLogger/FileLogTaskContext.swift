//
//  FileLogTaskContext.swift
//  file-logger
//
//  Created by Victor Chernykh on 19.09.2025.
//

import Logging

/// Task-local logger context.
enum FileLogTaskContext {
	@TaskLocal static var current: Logger?
}
