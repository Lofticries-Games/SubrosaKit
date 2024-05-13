//
//  SBRKit.Version.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 11.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRKit.Version

extension SBRKit {

    // MARK: - Public structure

    ///
    /// A structure describing the version of the framework as a major.minor.patch.
    ///
    public struct Version {

        // MARK: - Public properties

        ///
        /// A property that allows you to get the major version of the framework.
        ///
        public let major: UInt16

        ///
        /// A property that allows you to get the minor version of the framework.
        ///
        public let minor: UInt16

        ///
        /// A property that allows you to get the patch version of the framework.
        ///
        public let patch: UInt16
    }
}
