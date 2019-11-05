// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ac-content-upload-server",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.7.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-OpenAPI.git", from: "1.3.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Session.git", from: "3.3.4"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0"),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "5.1.11"),
        .package(url: "https://github.com/SwiftOnTheServer/SwiftDotEnv.git", from: "2.0.1"),
        // .package(url: "")
    ],
    targets: [
        .target(name: "ac-content-upload-server", dependencies: [ .target(name: "Application"), "Kitura", "HeliumLogger"]),
        .target(name: "Application", dependencies: [
            "Kitura",
            "KituraOpenAPI",
            "KituraSession",
            "MongoKitten",
            "SwiftDotEnv",
        ]),
        .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura" ])
    ]
)
