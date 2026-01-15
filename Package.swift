// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "T1DCalculator",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "T1DCalculator",
            targets: ["T1DCalculator"]
        )
    ],
    targets: [
        .target(
            name: "T1DCalculator",
            path: "."
        ),
        .testTarget(
            name: "T1DCalculatorTests",
            dependencies: ["T1DCalculator"],
            path: ".",
            sources: ["T1DCalculatorTests.swift"]
        )
    ]
)
