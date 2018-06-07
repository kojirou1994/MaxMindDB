// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "MaxMindDB",
    products: [
        .library(
            name: "MaxMindDB",
            targets: ["MaxMindDB"]),
        .library(
            name: "MaxMindDB_static",
            type: .static,
            targets: ["MaxMindDB"]),
        .library(
            name: "MaxMindDB_dynamic",
            type: .dynamic,
            targets: ["MaxMindDB"]),
        .executable(
            name: "MaxMindDB_cli",
            targets: ["MaxMindDB_cli"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Clibmaxminddb",
            dependencies: []),
        .target(
            name: "MaxMindDB",
            dependencies: ["Clibmaxminddb"]),
        .target(
            name: "MaxMindDB_cli",
            dependencies: ["MaxMindDB"]),
        .testTarget(
            name: "MaxMindDBTests",
            dependencies: ["MaxMindDB"]),
    ]
)
