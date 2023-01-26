// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "NewsMiniApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "NewsMiniApp",
            targets: ["NewsMiniApp"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NewsMiniApp",
            dependencies: []),
        .testTarget(
            name: "NewsMiniAppTests",
            dependencies: ["NewsMiniApp"]),
    ]
)
