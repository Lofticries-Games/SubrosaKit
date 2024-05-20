//
//  SBRConfidential.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidential

///
/// A class that implements a set of functionality for encryption and decryption with an available set of encryption algorithms.
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public final class SBRConfidential {

    // MARK: - Private properties

    private let algorithm: SBRConfidentable & SBRGeneratable



    // MARK: - Init

    ///
    /// An initializer that allows you to set the type of encryption from the available list, as well as the key size and/or hash value.
    ///
    /// The list of available methods of the SBRConfidential class is not available for all encryption types.
    ///
    /// Examples:
    ///
    ///     let algorithm = SBRConfidential(with: .sha2(hashValue: .bits256))
    ///
    /// An example of using AES encryption:
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits256))
    ///
    ///     let plainText = "Hello, world!"
    ///
    ///     Task {
    ///         let key = await aes.generateKey()
    ///
    ///         let encryptedData = await aes.encrypt(propertySet: .init(text: plainText, key: key))!
    ///         let decryptedText = await aes.decrypt(propertySet: .init(data: encryptedData, key: key))!
    ///     }
    ///
    /// An example of using EdDSA encryption:
    ///
    ///     let eddsa = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))
    ///
    ///     let dogPlainText = "woof-woof-woof"
    ///     let catPlainText = "meow-meow-meow"
    ///
    ///     Task {
    ///         let catKeyPair = await eddsa.generateKeyPair()!
    ///         let dogKeyPair = await eddsa.generateKeyPair()!
    ///
    ///         let salt = await eddsa.generateSalt()!
    ///
    ///         // Cat's symmetric key
    ///         let catSymmetricKey = await eddsa.generateKey(
    ///             for: .init(
    ///                 keyPair: .init(
    ///                     privateKey: catKeyPair.privateKey,
    ///                     publicKey: dogKeyPair.publicKey!
    ///                 ),
    ///                 salt: salt
    ///             )
    ///         )
    ///
    ///         // Dog's symmetric key
    ///         let dogSymmetricKey = await eddsa.generateKey(
    ///             for: .init(
    ///                 keyPair: .init(
    ///                     privateKey: dogKeyPair.privateKey,
    ///                     publicKey: catKeyPair.publicKey!
    ///                 ),
    ///                 salt: salt
    ///             )
    ///         )
    ///
    ///         print("Is cat & dog has the same keys? - ", (catSymmetricKey == dogSymmetricKey) ? "Yes" : "No") // Prints "Yes"
    ///
    ///         let catEncryptedData = await eddsa.encrypt(propertySet: .init(text: catPlainText, key: catSymmetricKey))!
    ///         let dogEncryptedData = await eddsa.encrypt(propertySet: .init(text: dogPlainText, key: dogSymmetricKey))!
    ///
    ///         let catDecryptedText = await eddsa.decrypt(propertySet: .init(data: dogEncryptedData, key: catSymmetricKey))!
    ///         let dogDecryptedText = await eddsa.decrypt(propertySet: .init(data: catEncryptedData, key: dogSymmetricKey))!
    ///     }
    ///
    /// An example of using SHA-2 hashing:
    ///
    ///     let sha2 = SBRConfidential(with: .sha2(hashValue: .bits512))
    ///
    ///     let plainText = "Hello, world!"
    ///
    ///     Task {
    ///         let encryptedData = await sha2.encrypt(propertySet: .init(text: plainText))!
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - encryptionType: List of available encryption types.
    ///
    public init(with encryptionType: EncryptionType) {
        switch encryptionType {
        case .aes(let keySize):
            algorithm = SBR_AES(keySize: keySize)
        case .eddsa(let hashValue, let keySize):
            algorithm = SBR_EdDSA(hashValue: hashValue, keySize: keySize)
        case .sha2(let hashValue):
            algorithm = SBR_SHA2(hashValue: hashValue)
        }
    }
}



// MARK: - SBRConfidentable

extension SBRConfidential: SBRConfidentable {

    // MARK: - Public methods

    ///
    /// The method used to encrypt the plain text.
    ///
    /// Example:
    ///
    ///     let plainText = "Hello, world!"
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits128))
    ///
    ///     Task {
    ///         let key = await aes.generateKey()
    ///
    ///         let encryptedData = await aes.encrypt(propertySet: .init(text: plainText, key: key))!
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - propertySet: The set of properties passed for encryption.
    ///
    /// - Returns: Encrypted plaintext.
    ///
    public func encrypt(propertySet: EncryptionPropertySet) async -> Data? {
        await algorithm.encrypt(propertySet: propertySet)
    }

    ///
    /// The method used to encrypt an array of plain texts.
    ///
    /// Example:
    ///
    ///     let plainTexts = ["Hello", "world"]
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits128))
    ///
    ///     Task {
    ///         let keys = await aes.generateKeys(with: UInt(plainTexts.count))
    ///
    ///         let propertySets: [SBRConfidential.EncryptionPropertySet] = [
    ///             .init(text: plainTexts[0], key: keys?[0]),
    ///             .init(text: plainTexts[1], key: keys?[1])
    ///         ]
    ///
    ///         let encryptedDatas = await aes.encrypt(propertySets: propertySets)!
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - propertySets: An array of property sets to be passed for encryption.
    ///
    /// - Returns: An array of encrypted plaintexts.
    ///
    public func encrypt(propertySets: [EncryptionPropertySet]) async -> [Data]? {
        await algorithm.encrypt(propertySets: propertySets)
    }

    ///
    /// The method used to decrypt the ciphertext.
    ///
    /// Example:
    ///
    ///     let encryptedData = "Hello, world!".data(using: .utf8)!
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits128))
    ///
    ///     Task {
    ///         // Key generated earlier
    ///         let key = await aes.generateKey()
    ///
    ///         let decryptedText = await aes.decrypt(propertySet: .init(data: encryptedData, key: key))!
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - propertySet: The set of properties passed for decryption.
    ///
    /// - Returns: Decrypted data.
    ///
    public func decrypt(propertySet: DecryptionPropertySet) async -> String? {
        await algorithm.decrypt(propertySet: propertySet)
    }

    ///
    /// The method used to decrypt an array of ciphertexts.
    ///
    /// Example:
    ///
    ///     let encryptedDatas = ["Hello, ", "world!"].map { $0.data(using: .utf8)! }
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits128))
    ///
    ///     Task {
    ///         // Keys generated earlier
    ///         let keys = await sut.generateKeys(with: UInt(encryptedDatas.count))
    ///
    ///         let propertySets: [SBRConfidential.DecryptionPropertySet] = [
    ///             .init(text: encryptedDatas[0], key: keys?[0]),
    ///             .init(text: encryptedDatas[1], key: keys?[1])
    ///         ]
    ///
    ///         let decryptedTexts = await aes.decrypt(propertySets: propertySets)!
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - propertySets: An array of property sets to be passed for decryption.
    ///
    /// - Returns: An array of decrypted data.
    ///
    public func decrypt(propertySets: [DecryptionPropertySet]) async -> [String]? {
        await algorithm.decrypt(propertySets: propertySets)
    }
}



// MARK: - SBRGeneratable

extension SBRConfidential: SBRGeneratable {

    // MARK: - Public methods

    ///
    /// A method that generates a symmetric key used for encryption and decryption.
    ///
    /// Example:
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits128))
    ///
    ///     Task {
    ///         let key = await aes.generateKey()
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - sharedSecret: A set of properties for recovering a symmetric key from a shared secret. The shared secret is only needed for the EdDSA encryption algorithm. The default value is nil.
    ///
    /// - Returns: The key is in the form of data.
    ///
    public func generateKey(for sharedSecret: SBRConfidential.SharedSecret? = nil) async -> Data? {
        await algorithm.generateKey(for: sharedSecret)
    }

    ///
    /// A method to generate an array of symmetric keys used for encryption and decryption.
    ///
    /// Example:
    ///
    ///     let aes = SBRConfidential(with: .aes(keySize: .bits128))
    ///
    ///     Task {
    ///         let keys = await aes.generateKeys()
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - numberOfSessions: The number of sessions for which keys generation is required. The default value is 10.
    ///    - sharedSecrets: An array of a set of properties to restore an array of symmetric keys from an array of shared secrets. The shared secret is only needed for the EdDSA encryption algorithm. The default value is nil.
    ///
    /// - Returns: An array of keys as data.
    ///
    func generateKeys(
        with numberOfSessions: UInt = 10,
        for sharedSecrets: [SBRConfidential.SharedSecret]? = nil
    ) async -> [Data]? {
        await algorithm.generateKeys(with: numberOfSessions, for: sharedSecrets)
    }

    ///
    /// A method that allows you to generate a pair consisting of a private and public keys.
    ///
    /// Used only for the EdDSA algorithm.
    ///
    /// Example:
    ///
    ///     let eddsa = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))
    ///
    ///     Task {
    ///         let keyPair = await eddsa.generateKeyPair()
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Returns: A key pair consisting of a private key and a public key.
    ///
    public func generateKeyPair() async -> SBRConfidential.KeyPair? {
        await algorithm.generateKeyPair()
    }

    ///
    /// A method that allows you to generate an array of pairs consisting of private and public keys.
    ///
    /// Used only for the EdDSA algorithm.
    ///
    /// Example:
    ///
    ///     let eddsa = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))
    ///
    ///     Task {
    ///         let keyPairs = await eddsa.generateKeyPairs()
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - numberOfSessions: The number of sessions for which key pair generation is required. The default value is 10.
    ///
    /// - Returns: An array of key pairs consisting of private and public keys.
    ///
    public func generateKeyPairs(with numberOfSessions: UInt = 10) async -> [SBRConfidential.KeyPair]? {
        await algorithm.generateKeyPairs(with: numberOfSessions)
    }

    ///
    /// A method to generate noise.
    ///
    /// Used only for the EdDSA algorithm.
    ///
    /// Example:
    ///
    ///     let eddsa = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))
    ///
    ///     Task {
    ///         let salt = await eddsa.generateSalt()
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Returns: Noise as data.
    ///
    public func generateSalt() async -> Data? {
        await algorithm.generateSalt()
    }

    ///
    /// A method that allows you to generate an array of noise.
    ///
    /// Used only for the EdDSA algorithm.
    ///
    /// Example:
    ///
    ///     let eddsa = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))
    ///
    ///     Task {
    ///         let salts = await eddsa.generateSalts()
    ///     }
    ///
    /// - Authors: Dmitry Novikov · Lofticries Games
    ///
    /// - Bug: None
    ///
    /// - Parameters:
    ///    - numberOfSessions: The number of sessions for which noise generation is required. The default value is 10.
    ///
    /// - Returns: An array of noise as data.
    ///
    public func generateSalts(with numberOfSessions: UInt = 10) async -> [Data]? {
        await algorithm.generateSalts(with: numberOfSessions)
    }
}
