// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACNetwork",
    platforms: [.iOS(.v16), .macOS(.v13), .visionOS(.v1), .tvOS(.v16), .watchOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ACNetwork",
            targets: ["ACNetwork"]),
    ],
    dependencies: [
            .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ACNetwork"),
        .testTarget(
            name: "ACNetworkTests",
            dependencies: ["ACNetwork"]),
    ]
)
