// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StringsScan",
    products: [
        .executable(name: "StringsScan", targets: ["StringsScan"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
        .package(url: "https://github.com/pvieito/PythonKit.git", branch: "master"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", branch: "stable")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "StringsScan",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "PythonKit", package: "PythonKit"),
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit")
            ]),
        .testTarget(
            name: "StringsScanTests",
            dependencies: ["StringsScan"]),
    ]
)
