// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "FITAWebWidget",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "FITAWebWidget",
            targets: ["FITAWebWidget"]
        )
    ],
    targets: [
        .target(
            name: "FITAWebWidget",
            path: "FitAnalytics-WebWidget"
        )
    ]
)
