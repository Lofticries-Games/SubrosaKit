//
//  SBRConfidential.KeySize.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.KeySize

extension SBRConfidential {

    // MARK: - Public enumeration

    ///
    /// An enumeration representing the size of the key in bits.
    ///
    public enum KeySize {

        ///
        /// The key is 128 bits.
        ///
        case bits128

        ///
        /// The key is 192 bits.
        ///
        case bits192

        ///
        /// The key is 256 bits.
        ///
        case bits256
    }
}
