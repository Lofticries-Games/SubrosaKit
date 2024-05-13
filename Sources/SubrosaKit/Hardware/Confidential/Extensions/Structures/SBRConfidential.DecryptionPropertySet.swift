//
//  SBRConfidential.DecryptionPropertySet.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.DecryptionPropertySet

extension SBRConfidential {

    // MARK: - Public struct

    ///
    /// A structure that describes a set of properties passed to the decryption methods of the SubrosaKit framework.
    ///
    public struct DecryptionPropertySet {

        // MARK: - Public properties

        ///
        /// A property that represents the data to be decrypted.
        ///
        public let data: Data

        ///
        /// A property that represents the key used for decryption.
        ///
        public let key: Data?



        // MARK: - Init

        ///
        /// An initializer that allows you to pass data for decryption.
        ///
        public init(
            data: Data,
            key: Data? = nil
        ) {
            self.data = data
            self.key = key
        }
    }
}
