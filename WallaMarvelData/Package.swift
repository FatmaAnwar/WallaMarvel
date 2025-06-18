// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "WallaMarvelData",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "WallaMarvelData",
            targets: ["WallaMarvelData"]
        ),
    ],
    dependencies: [
        .package(path: "../WallaMarvelDomain"),
        .package(path: "../WallaMarvelCore")
    ],
    targets: [
        .target(
            name: "WallaMarvelData",
            dependencies: [
                "WallaMarvelDomain",
                "WallaMarvelCore"
            ],
            path: "Sources/WallaMarvelData",
            resources: [
                .process("Cache/WallaMarvel.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "WallaMarvelDataTests",
            dependencies: ["WallaMarvelData"],
            path: "Tests/WallaMarvelDataTests"
        )
    ]
)
