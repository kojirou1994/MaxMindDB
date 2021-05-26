// swift-tools-version:5.4

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
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/DictionaryCoding.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CMaxMindDB",
          resources: [
            .copy("LICENSE"),
          ]),
        .target(
            name: "MaxMindDB",
            dependencies: ["CMaxMindDB", "DictionaryCoding"]),
        .executableTarget(
            name: "MaxMindDB-cli",
            dependencies: ["MaxMindDB"]),
        .testTarget(
            name: "MaxMindDBTests",
            dependencies: ["MaxMindDB"]),
    ]
)
