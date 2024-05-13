//
//  SBRConfidential.EncryptionPropertySet.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.EncryptionPropertySet

extension SBRConfidential {

    // MARK: - Public struct

    ///
    /// A structure that describes a set of properties passed to the encryption methods of the SubrosaKit framework.
    ///
    public struct EncryptionPropertySet {

        // MARK: - Public properties

        ///
        /// A property that represents the plaintext to encrypt.
        ///
        public let text: String

        ///
        /// A property that represents the key used for encryption.
        ///
        public let key: Data?



        // MARK: - Init

        ///
        /// An initializer that allows you to pass data for encryption.
        ///
        public init(
            text: String,
            key: Data? = nil
        ) {
            self.text = text
            self.key = key
        }
    }
}
