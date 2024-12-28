// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "CocktailsAPI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // The library that can be imported by other targets
        .library(
            name: "CocktailsAPI",
            targets: ["CocktailsAPI"]
        ),
    ],
    dependencies: [
        // Add external dependencies here if needed
    ],
    targets: [
        // Define the CocktailsAPI target
        .target(
            name: "CocktailsAPI",
            dependencies: []
        ),
        .testTarget(
            name: "CocktailsAPITests",
            dependencies: ["CocktailsAPI"]
        ),
    ]
)
