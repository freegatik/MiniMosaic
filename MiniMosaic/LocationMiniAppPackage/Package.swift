// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "LocationMiniApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "LocationMiniApp",
            targets: ["LocationMiniApp"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LocationMiniApp",
            dependencies: []),
        .testTarget(
            name: "LocationMiniAppTests",
            dependencies: ["LocationMiniApp"]),
    ]
)

