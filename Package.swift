// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let configurationMode = "dev" //ProcessInfo.processInfo.environment["CONFIGURATION_MODE"] ?? "dev"

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
                .package(path: "../MealzUIModuleIOS"),
                .package(path: "../MealzNavModuleIOS"),
                .package(path: "../MealzCore"),
                .package(path: "../MealzIOSFramework")
            ]
            )
        } else if configurationMode == "devWithSPM" {
            dependencies.append(contentsOf: [
                .package(path: "../MealzUIModuleIOS"),
                .package(path: "../MealzNavModuleIOS"),
                .package(path: "../MealzCore"),
                .package(path: "../MealzIOSFrameworkSPM")
            ]
            )
        } else {
            dependencies.append(contentsOf: [
                .package(url: "https://github.com/miamtech/releaseMealz", from: "1.0.0-beta3"),
                .package(url: "https://github.com/miamtech/MealzIOSFrameworkSPM", exact: "1.0.0-beta4"),
                .package(url: "https://github.com/miamtech/MealzUIModuleIOS", from: "1.0.2-beta3"),
                .package(url: "https://github.com/miamtech/MealzNavModuleIOS", from: "1.0.2-beta2")
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
            var dependencies: [Target.Dependency] = [
                .product(name: "MealzUIModuleIOS", package: "MealzUIModuleIOS"),
                .product(name: "MealzNavModuleIOS", package: "MealzNavModuleIOS")
            ]
            if configurationMode == "dev" {
                dependencies.append(contentsOf: [
                    .product(name: "MealzCore", package: "MealzCore"),
                    .product(name: "MealzIOSFramework", package: "MealzIOSFramework")
                ]
                )
            } else if configurationMode == "devWithSPM" {
                dependencies.append(contentsOf: [
                    .product(name: "MealzCore", package: "MealzCore"),
                    .product(name: "MealzIOSFrameworkSPM", package: "MealzIOSFrameworkSPM")
                ]
                )
            } else {
                dependencies.append(contentsOf: [
                    .product(name: "MealzCore", package: "releaseMealz"),
                    .product(name: "MealzIOSFrameworkSPM", package: "MealzIOSFrameworkSPM")
                ]
                )
            }
            return dependencies
        }(),
            resources: [.copy("Ressources"), .copy("PrivacyInfo.xcprivacy")]
        )
    ]
)
