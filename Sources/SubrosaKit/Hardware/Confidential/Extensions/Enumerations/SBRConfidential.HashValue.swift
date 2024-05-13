//
//  SBRConfidential.HashValue.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.HashValue

extension SBRConfidential {

    // MARK: - Public enumeration

    ///
    /// An enumeration that is a list of available hash values.
    ///
    public enum HashValue {

        ///
        /// The hash is 256 bits.
        ///
        case bits256

        ///
        /// The hash is 384 bits.
        ///
        case bits384

        ///
        /// The hash is 512 bits.
        ///
        case bits512
    }
}
