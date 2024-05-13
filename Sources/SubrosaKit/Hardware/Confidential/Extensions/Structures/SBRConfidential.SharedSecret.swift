//
//  SBRConfidential.SharedSecret.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.SharedSecret

extension SBRConfidential {

    // MARK: - Public struct

    ///
    /// A structure representing a shared secret of a set of two keys and noise used to recover a symmetric key used for encryption and decryption in the SubrosaKit framework.
    ///
    public struct SharedSecret {

        // MARK: - Public properties

        ///
        /// A property that is a pair of keys.
        ///
        public let keyPair: KeyPair

        ///
        /// A property that represents random noise.
        ///
        public let salt: Data?



        // MARK: - Init

        ///
        /// An initializer that allows you to pass data to get the shared secret.
        ///
        public init(
            keyPair: KeyPair,
            salt: Data? = nil
        ) {
            self.keyPair = keyPair
            self.salt = salt
        }
    }
}
