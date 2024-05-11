//
//  SBRKit.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 11.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRKit

///
/// A class that implements the framework specification.
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
public final class SBRKit: SBRKitSpecificationable {

    // MARK: - Static properties

    ///
    /// A shared instance that provides access to the properties of the service.
    ///
    public static let info: SBRKitSpecificationable = SBRKit()



    // MARK: - Public properties

    ///
    /// A property that allows you to get the version of the framework being used.
    ///
    public let version = Version(major: 1, minor: 0, patch: 0)

    ///
    /// A property that allows you to get the build version of the framework being used.
    ///
    public let build: Build = 11



    // MARK: - Init

    private init() { }
}
