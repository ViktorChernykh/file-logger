//
//  NetworkError.swift
//  finam-rest
//
//  Created by Victor Chernykh on 14.06.2025.
//

public enum NetworkError: Error {
	case invalidURL(from: String)

	public var description: String {
		switch self {
		case let .invalidURL(string):
			return "Cannot create url from: \(string)"
		}
	}
}
