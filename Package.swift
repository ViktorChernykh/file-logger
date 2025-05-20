// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "file-logger",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "FileLogger", targets: ["FileLogger"]),
    ],
    dependencies: [
		.package(url: "https://github.com/apple/swift-log.git", from: "1.6.0")
	],
    targets: [
        .target(name: "FileLogger", dependencies: [
			.product(name: "Logging", package: "swift-log")
		]),
    ]
)
