// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "swift-benchmarks",
    products: [
        .executable(
            name: "unmanaged",
            targets: ["unmanaged"]),
        .executable(
            name: "naive",
            targets:["naive"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "unmanaged",
            dependencies: []),
        .target(
            name: "naive",
            dependencies: []),
    ]
)
