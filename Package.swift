// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let configurationMode = "prod" //ProcessInfo.processInfo.environment["CONFIGURATION_MODE"] ?? "dev"

let package = Package(
    name: "MarmitonUIMealzIOS",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MarmitonUIMealzIOS",
            targets: ["MarmitonUIMealzIOS"]),
    ],
    dependencies: {
        var dependencies: [Package.Dependency] = []
        
        if configurationMode == "dev" {
            dependencies.append(contentsOf: [
                .package(path: "../MealzUIiOSSDK"),
                .package(path: "../MealzNaviOSSDK"),
                .package(path: "../MealzCore"),
                .package(path: "../MealziOSSDK")
            ]
            )
        } else if configurationMode == "devWithSPM" {
            dependencies.append(contentsOf: [
                .package(path: "../MealzUIiOSSDKRelease"),
                .package(path: "../MealzNaviOSSDKRelease"),
                .package(path: "../MealzCoreRelease"),
                .package(path: "../MealziOSSDKRelease")
            ]
            )
        } else {
            dependencies.append(contentsOf: [
                .package(url: "https://github.com/miamtech/MealzCoreRelease", from: "4.1.0"),
                .package(url: "https://github.com/miamtech/MealziOSSDKRelease", exact: "4.1.0"),
                .package(url: "https://github.com/miamtech/MealzUIiOSSDKRelease", from: "4.1.0"),
                .package(url: "https://github.com/miamtech/MealzNaviOSSDKRelease", from: "4.1.0")
            ]
            )
        }
        return dependencies
    }(),
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MarmitonUIMealzIOS",
        dependencies: {
            var dependencies: [Target.Dependency] = []
            if configurationMode == "dev" {
                dependencies.append(contentsOf: [
                    .product(name: "MealzUIiOSSDK", package: "MealzUIiOSSDK"),
                    .product(name: "MealzNaviOSSDK", package: "MealzNaviOSSDK"),
                    .product(name: "MealzCore", package: "MealzCore"),
                    .product(name: "MealziOSSDK", package: "MealziOSSDK")
                ]
                )
            } else {
                dependencies.append(contentsOf: [
                    .product(name: "MealzUIiOSSDK", package: "MealzUIiOSSDKRelease"),
                    .product(name: "MealzNaviOSSDK", package: "MealzNaviOSSDKRelease"),
                    .product(name: "MealzCore", package: "MealzCoreRelease"),
                    .product(name: "MealziOSSDK", package: "MealziOSSDKRelease")
                ]
                )
            }
            return dependencies
        }(),
            resources: [.copy("Ressources"), .process("Localization"), .copy("PrivacyInfo.xcprivacy")]
        )
    ]
)
