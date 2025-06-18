// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WallaMarvelCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "WallaMarvelCore", targets: ["WallaMarvelCore"])
    ],
    targets: [
        .target(
            name: "WallaMarvelCore",
            path: "Sources/WallaMarvelCore"
        ),
        .testTarget(
            name: "WallaMarvelCoreTests",
            dependencies: ["WallaMarvelCore"],
            path: "Tests/WallaMarvelCoreTests"
        ),
    ]
)
