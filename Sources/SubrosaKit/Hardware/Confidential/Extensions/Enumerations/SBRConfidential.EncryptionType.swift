//
//  SBRConfidential.EncryptionType.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential.EncryptionType

extension SBRConfidential {

    // MARK: - Public enumeration

    ///
    /// An enumeration that is a list of available encryption algorithms.
    ///
    public enum EncryptionType {

        ///
        /// Advanced Encryption Standard [AES] is a symmetric block encryption algorithm (block size 128 bits, key 128 / 192 / 256 bits) adopted as an encryption standard by the US government.
        ///
        case aes(keySize: KeySize)

        ///
        /// Edwards-curve Digital Signature Algorithm [EdDSA] is a digital signature scheme (in public-key cryptographic systems) using a variant of the Edwards Elliptic Curve Schnor scheme.
        ///
        case eddsa(hashValue: HashValue, keySize: KeySize)

        ///
        /// Secure Hash Algorithm 2 [SHA-2] is a secure hashing algorithm of the second version. A family of cryptographic algorithms - one-way hash functions, including algorithms, SHA-256, SHA-384, SHA-512.
        ///
        case sha2(hashValue: HashValue)
    }
}
