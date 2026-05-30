// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "XiaoyaGrowth",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "XiaoyaGrowthCore",
            targets: ["XiaoyaGrowthCore"]
        )
    ],
    targets: [
        .target(
            name: "XiaoyaGrowthCore"
        ),
        .testTarget(
            name: "XiaoyaGrowthCoreTests",
            dependencies: ["XiaoyaGrowthCore"]
        )
    ]
)
