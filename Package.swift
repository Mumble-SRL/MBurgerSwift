// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MBurgerSwift",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MBurgerSwift",
            targets: ["MBurgerSwift"])

    ],
    dependencies: [
        .package(url: "https://github.com/Mumble-SRL/MBNetworkingSwift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MBurgerSwift",
            dependencies: ["MBNetworkingSwift"],
            path: "MBurgerSwift"
        ),
        .testTarget(
            name: "MBurgerSwiftTests",
            dependencies: ["MBurgerSwift"],
            path: "MBurgerSwiftTests")
    ]
)
