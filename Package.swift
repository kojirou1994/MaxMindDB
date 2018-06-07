// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "MaxMindDB",
    products: [
        .library(
            name: "MaxMindDB",
            targets: ["MaxMindDB"]),
        .executable(
            name: "MaxMindDB-cli",
            targets: ["MaxMindDB-cli"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kojirou1994/Clibmaxminddb", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MaxMindDB",
            dependencies: []),
        .target(
            name: "MaxMindDB-cli",
            dependencies: ["MaxMindDB"]),
        .testTarget(
            name: "MaxMindDBTests",
            dependencies: ["MaxMindDB"]),
    ]
)
