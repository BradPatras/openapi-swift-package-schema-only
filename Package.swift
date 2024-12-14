// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenAPISwiftPackageSchemaOnly",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OpenAPISwiftPackageSchemaOnly",
            targets: ["OpenAPISwiftPackageSchemaOnly"]),
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OpenAPISwiftPackageSchemaOnly",
			dependencies: [
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
			],
			plugins: [.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")]),
    ]
)
