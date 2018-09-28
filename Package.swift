// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-regex",
    products: [
        .library(name: "CPOSIXRegex", targets: ["CPOSIXRegex"]),
        .library(name: "POSIXRegex", targets: ["POSIXRegex"]),
        .library(name: "SwiftRegex", targets: ["SwiftRegex"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "CPOSIXRegex", dependencies: []),
        .target(name: "POSIXRegex", dependencies: ["SwiftRegex", "CPOSIXRegex"]),
        .target(name: "SwiftRegex", dependencies: []),
        .testTarget(name: "POSIXRegexTests", dependencies: ["POSIXRegex"]),
    ]
)
