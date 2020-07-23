// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MBurgerSwift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MBurgerSwift",
            targets: ["MBurgerSwift"])

    ],
    dependencies: [
        .package(url: "https://github.com/Mumble-SRL/MBNetworkingSwift.git", from: "1.0.0"),
        .package(url: "https://github.com/soffes/SAMKeychain.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "MBurgerSwift",
            dependencies: [],
            path: "MBurgerSwift"
        ),
        .testTarget(
            name: "MBurgerSwiftTests",
            dependencies: ["MBurgerSwift"])
    ]
)
