// swift-tools-version: 5.9
import PackageDescription

// SwiftPM builds only the calculation engine so `swift test` can run on macOS
// with Xcode, or with Command Line Tools plus Xcode.app installed. The SwiftUI
// views and app entry point are built by the Xcode app project (see README.md
// > Installation).
let package = Package(
    name: "T1DCalculator",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
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
            path: ".",
            sources: ["InsulinCalculator.swift"]
        ),
        .testTarget(
            name: "T1DCalculatorTests",
            dependencies: ["T1DCalculator"],
            path: ".",
            sources: [
                "T1DCalculatorTests.swift",
                "T1DCalculatorTests_Enhanced.swift"
            ]
        )
    ]
)
