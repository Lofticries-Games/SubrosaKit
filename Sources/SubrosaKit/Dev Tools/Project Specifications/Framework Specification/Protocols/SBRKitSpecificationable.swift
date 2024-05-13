//
//  SBRKitSpecificationable.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 11.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRKitSpecificationable

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public protocol SBRKitSpecificationable: AnyObject {

    // MARK: - Public properties

    var version: SBRKit.Version { get }
    var build: SBRKit.Build { get }
}
