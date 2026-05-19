// swift-tools-version: 5.9
import PackageDescription

// NOTE: This Package.swift is kept for reference but not used for the iOS app.
// The app uses an Xcode project (.xcodeproj) instead.
// See CREATE_XCODE_PROJECT.md for instructions.

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
            path: ".",
            exclude: [
                "T1DCalculatorTests.swift",
                "T1DCalculatorTests_Enhanced.swift",
                "README.md",
                "SESSION_CONTEXT.md",
                "PROJECT_STATUS.md",
                "QA_TESTING_PLAN.md",
                "QA_CHECKLIST.md",
                "TESTING_QUICKSTART.md",
                "CHANGES_SUMMARY.md",
                "CREATE_XCODE_PROJECT.md"
            ]
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
