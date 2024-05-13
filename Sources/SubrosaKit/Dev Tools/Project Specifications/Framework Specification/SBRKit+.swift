//
//  SBRKit+.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 11.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - CustomStringConvertible

extension SBRKit: CustomStringConvertible {

    // MARK: - Public properties

    ///
    /// Representation of the version and build in string form.
    ///
    public var description: String {
        "\(version.major).\(version.minor).\(version.patch) · \(build)"
    }
}
