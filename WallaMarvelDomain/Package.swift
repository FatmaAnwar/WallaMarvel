// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WallaMarvelDomain",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "WallaMarvelDomain",
            targets: ["WallaMarvelDomain"]
        ),
    ],
    targets: [
        .target(
            name: "WallaMarvelDomain",
            path: "Sources/WallaMarvelDomain"
        ),
        .testTarget(
            name: "WallaMarvelDomainTests",
            dependencies: ["WallaMarvelDomain"],
            path: "Tests/WallaMarvelDomainTests"
        )
    ]
)
