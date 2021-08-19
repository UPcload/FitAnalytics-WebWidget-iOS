// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FitAnalyticsWebWidget",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "FitAnalyticsWebWidget",
            targets: ["FitAnalyticsWebWidget"]
        )
    ],
    targets: [
        .target(
            name: "FITAWebWidget",
            path: "FitAnalytics-WebWidget",
            publicHeadersPath: "./"
        ),
        .target(
            name: "FitAnalyticsWebWidget",
            dependencies: ["FITAWebWidget"],
            path: "Swift"
        )
    ]
)
