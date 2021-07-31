// swift-tools-version:5.4

import PackageDescription

let package = Package(
  name: "MaxMindDB",
  platforms: [
    .macOS(.v10_12),
    .iOS(.v10),
    .tvOS(.v10),
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
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.4.3"),
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
      name: "mmdb-cli",
      dependencies: [
        "MaxMindDB",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]),
    .testTarget(
      name: "MaxMindDBTests",
      dependencies: ["MaxMindDB"]),
  ]
)
