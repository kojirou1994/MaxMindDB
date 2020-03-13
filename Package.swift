// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MaxMindDB",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "MaxMindDB",
            targets: ["MaxMindDB"]),
        .library(
            name: "MaxMindDB-static",
            type: .static,
            targets: ["MaxMindDB"]),
        .library(
            name: "MaxMindDB-dynamic",
            type: .dynamic,
            targets: ["MaxMindDB"]),
        .executable(
            name: "MaxMindDB-cli",
            targets: ["MaxMindDB-cli"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/DictionaryCoding", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Clibmaxminddb",
            dependencies: []),
        .target(
            name: "MaxMindDB",
            dependencies: ["Clibmaxminddb", "DictionaryCoding"]),
        .target(
            name: "MaxMindDB-cli",
            dependencies: ["MaxMindDB"]),
        .testTarget(
            name: "MaxMindDBTests",
            dependencies: ["MaxMindDB"]),
    ]
)
