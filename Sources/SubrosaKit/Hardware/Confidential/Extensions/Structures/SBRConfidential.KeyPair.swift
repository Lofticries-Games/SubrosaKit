//
//  SBRConfidential.KeyPair.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.KeyPair

extension SBRConfidential {

    // MARK: - Public struct

    ///
    /// A structure that is a key pair used for encryption and decryption in the SubrosaKit framework.
    ///
    public struct KeyPair {

        // MARK: - Public properties

        ///
        /// A property that represents the private key used to decrypt the data.
        ///
        public let privateKey: Data

        ///
        /// A property that represents the public key used to encrypt data and also recover the symmetric key.
        ///
        public let publicKey: Data?



        // MARK: - Init

        ///
        /// An initializer that allows you to pass key data.
        ///
        public init(
            privateKey: Data,
            publicKey: Data? = nil
        ) {
            self.privateKey = privateKey
            self.publicKey = publicKey
        }
    }
}
