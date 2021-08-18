// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "FitAnalytics-WebWidget",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "FitAnalytics-WebWidget",
            targets: ["FitAnalytics-WebWidget"]
        )
    ],
    targets: [
        .target(
            name: "FitAnalytics-WebWidget",
            path: "FitAnalytics-WebWidget"
        )
    ]
)
