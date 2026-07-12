// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TodoApp",
    targets: [
        .executableTarget(
            name: "TodoApp",
            path: "Sources"),
        .testTarget(
            name: "TodoAppTests",
            dependencies: ["TodoApp"],
            path: "Tests"),
    ]
)