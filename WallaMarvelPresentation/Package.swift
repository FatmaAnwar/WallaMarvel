// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WallaMarvelPresentation",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "WallaMarvelPresentation",
            targets: ["WallaMarvelPresentation"]
        ),
    ],
    dependencies: [
        .package(path: "../WallaMarvelDomain"),
        .package(path: "../WallaMarvelCore"),
        .package(path: "../WallaMarvelData")
    ],
    targets: [
        .target(
            name: "WallaMarvelPresentation",
            dependencies: [
                "WallaMarvelDomain",
                "WallaMarvelCore",
                "WallaMarvelData"
            ],
            path: "Sources/WallaMarvelPresentation"
        ),
        .testTarget(
            name: "WallaMarvelPresentationTests",
            dependencies: ["WallaMarvelPresentation"],
            path: "Tests/WallaMarvelPresentationTests"
        )
    ]
)
