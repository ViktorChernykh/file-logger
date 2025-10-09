// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "file-logger",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "FileLogger", targets: ["FileLogger"]),
    ],
    dependencies: [
		.package(url: "https://github.com/apple/swift-log.git", from: "1.6.0")
	],
	targets: [
		.target(
			name: "FileLogger",
			dependencies: [
				.product(name: "Logging", package: "swift-log")
			],
			/// Swift compiler settings for Release configuration.
			swiftSettings: swiftSettings,
		),
		.testTarget(name: "FileLoggerTests", dependencies: ["FileLogger"]),
	]
)

/// Swift compiler settings for Release configuration.
var swiftSettings: [SwiftSetting] { [
	// "ExistentialAny" is an option that makes the use of the `any` keyword for existential types `required`
	.enableUpcomingFeature("ExistentialAny")
] }
