//
//  SBR_EdDSA.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import CryptoKit
import Foundation



// MARK: - SBR_EdDSA

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
final class SBR_EdDSA {

    // MARK: - Private properties

    private let hashValue: SBRConfidential.HashValue

    private let aes: SBRConfidentable & SBRGeneratable



    // MARK: - Init

    init(
        hashValue: SBRConfidential.HashValue,
        keySize: SBRConfidential.KeySize
    ) {
        self.hashValue = hashValue

        aes = SBR_AES(keySize: keySize)
    }



    // MARK: - Private functions

    private func encrypt(_ text: String, key: Data) async -> Data? {
        await aes.encrypt(propertySet: .init(text: text, key: key))
    }

    private func decrypt(_ data: Data, key: Data) async -> String? {
        await aes.decrypt(propertySet: .init(data: data, key: key))
    }
}



// MARK: - SBRConfidentable

extension SBR_EdDSA: SBRConfidentable {

    // MARK: - Public methods

    func encrypt(propertySet: SBRConfidential.EncryptionPropertySet) async -> Data? {
        let text = propertySet.text

        guard let key = propertySet.key else { return nil }

        return await encrypt(text, key: key)
    }

    func encrypt(propertySets: [SBRConfidential.EncryptionPropertySet]) async -> [Data]? {
        let encryptedDatas = await withTaskGroup(
            of: (Data?, Int).self,
            returning: [Data].self
        ) { group in
            propertySets
                .enumerated()
                .forEach { (index, propertySet) in
                    group.addTask {
                        let encryptedData = await self.encrypt(propertySet: propertySet)

                        return (encryptedData, index)
                    }
                }

            return await group
                .reduce(into: [(Data?, Int)]()) { $0.append($1) }
                .sorted { $0.1 < $1.1 }
                .compactMap { $0.0 }
        }

        return (encryptedDatas.count == propertySets.count) ? encryptedDatas : nil
    }

    func decrypt(propertySet: SBRConfidential.DecryptionPropertySet) async -> String? {
        let data = propertySet.data

        guard let key = propertySet.key else { return nil }

        return await decrypt(data, key: key)
    }

    func decrypt(propertySets: [SBRConfidential.DecryptionPropertySet]) async -> [String]? {
        let decryptedTexts = await withTaskGroup(
            of: (String?, Int).self,
            returning: [String].self
        ) { group in
            propertySets
                .enumerated()
                .forEach { (index, propertySet) in
                    group.addTask {
                        let decryptedText = await self.decrypt(propertySet: propertySet)

                        return (decryptedText, index)
                    }
                }

            return await group
                .reduce(into: [(String?, Int)]()) { $0.append($1) }
                .sorted { $0.1 < $1.1 }
                .compactMap { $0.0 }
        }

        return (decryptedTexts.count == propertySets.count) ? decryptedTexts : nil
    }
}



// MARK: - SBRGeneratable

extension SBR_EdDSA: SBRGeneratable {

    // MARK: - Public methods

    func generateKey(for sharedSecret: SBRConfidential.SharedSecret?) async -> Data? {
        guard
            let privateKeyData = sharedSecret?.keyPair.privateKey,
            let publicKeyData = sharedSecret?.keyPair.publicKey,
            let salt = sharedSecret?.salt,
            let privateKey = try? Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData),
            let publicKey = try? Curve25519.KeyAgreement.PublicKey(rawRepresentation: publicKeyData),
            let secret = try? privateKey.sharedSecretFromKeyAgreement(with: publicKey)
        else {
            return nil
        }

        let symmetricKey: SymmetricKey

        switch hashValue {
        case .bits256:
            symmetricKey = secret.hkdfDerivedSymmetricKey(
                using: SHA256.self,
                salt: salt,
                sharedInfo: Data(),
                outputByteCount: 32
            )
        case .bits384:
            symmetricKey = secret.hkdfDerivedSymmetricKey(
                using: SHA384.self,
                salt: salt,
                sharedInfo: Data(),
                outputByteCount: 32
            )
        case .bits512:
            symmetricKey = secret.hkdfDerivedSymmetricKey(
                using: SHA512.self,
                salt: salt,
                sharedInfo: Data(),
                outputByteCount: 32
            )
        }

        let symmetricKeyData = symmetricKey.withUnsafeBytes { Data($0) }

        let wrappedKey = await aes.generateKey(for: .init(keyPair: .init(privateKey: symmetricKeyData)))

        return wrappedKey
    }

    func generateKeys(
        with numberOfSessions: UInt = 0,
        for sharedSecrets: [SBRConfidential.SharedSecret]?
    ) async -> [Data]? {
        guard let sharedSecrets else {
            return nil
        }

        let generatedKeys = await withTaskGroup(
            of: Data?.self,
            returning: [Data].self
        ) { group in
            sharedSecrets.forEach { sharedSecret in
                group.addTask {
                    await self.generateKey(for: sharedSecret)
                }
            }

            return await group
                .reduce(into: [Data?]()) { $0.append($1) }
                .compactMap { $0 }
        }

        return (generatedKeys.count == numberOfSessions) ? generatedKeys : nil
    }

    func generateKeyPair() async -> SBRConfidential.KeyPair? {
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey

        let privateKeyData = privateKey.rawRepresentation
        let publicKeyData = publicKey.rawRepresentation

        return .init(privateKey: privateKeyData, publicKey: publicKeyData)
    }

    func generateKeyPairs(with numberOfSessions: UInt = 10) async -> [SBRConfidential.KeyPair]? {
        guard numberOfSessions != 0 else {
            return nil
        }

        let generatedKeyPairs = await withTaskGroup(
            of: SBRConfidential.KeyPair?.self,
            returning: [SBRConfidential.KeyPair].self
        ) { group in
            (0 ..< numberOfSessions).forEach { _ in
                group.addTask {
                    await self.generateKeyPair()
                }
            }

            return await group
                .reduce(into: [SBRConfidential.KeyPair?]()) { $0.append($1) }
                .compactMap { $0 }
        }

        return (generatedKeyPairs.count == numberOfSessions) ? generatedKeyPairs : nil
    }

    func generateSalt() async -> Data? {
        let lowerBound: UInt8 = 0
        let upperBound: UInt8 = .random(in: (lowerBound + 1) ... (.max / 4))

        return await withTaskGroup(
            of: String.self,
            returning: Data?.self
        ) { group in
            (lowerBound ... upperBound).forEach { index in
                group.addTask {
                    let uuidString = UUID().uuidString

                    let offset = Int.random(in: 0 ... (uuidString.count - 1))

                    let symbol = uuidString[uuidString.index(uuidString.startIndex, offsetBy: offset)]

                    let newSymbol = symbol.isPunctuation ? "" : "\(symbol)"

                    return index.isMultiple(of: 2) ? newSymbol.uppercased() : newSymbol.lowercased()
                }
            }

            return await group
                .reduce(into: "") { $0 += $1 }
                .data(using: .utf8)
        }
    }

    func generateSalts(with numberOfSessions: UInt = 10) async -> [Data]? {
        guard numberOfSessions != 0 else {
            return nil
        }

        let generatedSalts = await withTaskGroup(
            of: Data?.self,
            returning: [Data].self
        ) { group in
            (0 ..< numberOfSessions).forEach { _ in
                group.addTask {
                    await self.generateSalt()
                }
            }

            return await group
                .reduce(into: [Data?]()) { $0.append($1) }
                .compactMap { $0 }
        }

        return (generatedSalts.count == numberOfSessions) ? generatedSalts : nil
    }
}
