// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.


//
//  Package.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 11.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import PackageDescription



// MARK: - // MARK: - Swift Package

let package = Package(
    name: "Subrosa Confidential",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SubrosaKit",
            targets: ["SubrosaKit"]
        )
    ],
    targets: [
        .target(name: "SubrosaKit"),
        .testTarget(
            name: "SubrosaKitTests",
            dependencies: ["SubrosaKit"]
        )
    ]
)
