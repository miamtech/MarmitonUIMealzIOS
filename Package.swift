// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let configurationMode = "dev"

let package = Package(
    name: "MarmitonUIMealzIOS",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MarmitonUIMealzIOS",
            targets: ["MarmitonUIMealzIOS"]
        )
    ],
    dependencies: {
        var dependencies: [Package.Dependency] = []

        if configurationMode == "dev" {
            dependencies.append(contentsOf: [
                .package(path: "../MealziOSSDK")
            ]
            )
        } else if configurationMode == "staging" {
            dependencies.append(contentsOf: [
                .package(path: "../MealziOSSDK/MealziOSSDK")
            ]
            )
        } else if configurationMode == "devWithSPM" {
            dependencies.append(contentsOf: [
                .package(path: "../MealzCoreRelease"),
                .package(path: "../MealziOSSDKRelease")
            ]
            )
        } else {
            dependencies.append(contentsOf: [
                .package(
                    url: "https://github.com/miamtech/MealziOSSDKRelease",
                    from: "5.10.2"
                ),
                .package(
                    url: "https://github.com/miamtech/MealzCoreRelease",
                    from: "5.10.2"
                )
            ]
            )
        }
        return dependencies
    }(),
    targets: [
        .target(
            name: "MarmitonUIMealzIOS",
            dependencies: {
                var dependencies: [Target.Dependency] = []
                if configurationMode == "dev" {
                    dependencies.append(contentsOf: [
                        .product(name: "MealziOSSDK", package: "MealziOSSDK")
                    ]
                    )
                } else if configurationMode == "staging" {
                    dependencies.append(contentsOf: [
                        .product(name: "MealziOSSDK", package: "MealziOSSDK")
                    ]
                    )
                } else {
                    dependencies.append(contentsOf: [
                        .product(
                            name: "MealzCore",
                            package: "MealzCoreRelease"
                        ),
                        .product(
                            name: "MealziOSSDK",
                            package: "MealziOSSDKRelease"
                        )
                    ]
                    )
                }
                return dependencies
            }(),
            resources: [.copy("Ressources"), .process("Localization"), .copy("PrivacyInfo.xcprivacy")]
        )
    ]
)
