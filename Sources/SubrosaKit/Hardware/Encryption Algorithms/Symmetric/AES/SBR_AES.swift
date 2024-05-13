//
//  SBR_AES.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import CryptoKit
import Foundation



// MARK: - SBR_AES

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
final class SBR_AES {

    // MARK: - Private properties

    private let keySize: SBRConfidential.KeySize

    private let kek128: SymmetricKey = {
        let data = "com.ddec.subrosa".data(using: .utf8)!

        return .init(data: data)
    }()

    private let kek192: SymmetricKey = {
        let data = "$#@%com.ddec.subrosa%@#$".data(using: .utf8)!

        return .init(data: data)
    }()

    private let kek256: SymmetricKey = {
        let data = "$#@%com@&._*ddec*_.&@subrosa%@#$".data(using: .utf8)!

        return .init(data: data)
    }()



    // MARK: - Init

    init(keySize: SBRConfidential.KeySize) {
        self.keySize = keySize
    }



    // MARK: - Private functions

    private func encrypt(_ text: String, key: Data) -> Data? {
        guard let data = text.data(using: .utf8) else {
            return nil
        }

        let wrappedKey = key

        let kek: SymmetricKey

        switch keySize {
        case .bits128:
            kek = kek128
        case .bits192:
            kek = kek192
        case .bits256:
            kek = kek256
        }

        guard
            let unwrappedKey = try? AES.KeyWrap.unwrap(wrappedKey, using: kek),
            let encryptedData = try? AES.GCM.seal(data, using: unwrappedKey)
        else {
            return nil
        }

        return encryptedData.combined
    }

    private func decrypt(_ data: Data, key: Data) -> String? {
        let data = data

        let wrappedKey = key

        guard let sealedBox = try? AES.GCM.SealedBox(combined: data) else {
            return nil
        }

        let kek: SymmetricKey

        switch keySize {
        case .bits128:
            kek = kek128
        case .bits192:
            kek = kek192
        case .bits256:
            kek = kek256
        }

        guard
            let unwrappedKey = try? AES.KeyWrap.unwrap(wrappedKey, using: kek),
            let decryptedData = try? AES.GCM.open(sealedBox, using: unwrappedKey)
        else {
            return nil
        }

        return .init(data: decryptedData, encoding: .utf8)
    }
}



// MARK: - SBRConfidentable

extension SBR_AES: SBRConfidentable {

    // MARK: - Public methods

    func encrypt(propertySet: SBRConfidential.EncryptionPropertySet) async -> Data? {
        let text = propertySet.text

        guard let key = propertySet.key else {
            return nil
        }

        return encrypt(text, key: key)
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

        guard let key = propertySet.key else {
            return nil
        }

        return decrypt(data, key: key)
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

extension SBR_AES: SBRGeneratable {

    // MARK: - Public methods

    func generateKey(for sharedSecret: SBRConfidential.SharedSecret? = nil) async -> Data? {
        let symmetricKey: SymmetricKey

        let kek: SymmetricKey

        switch keySize {
        case .bits128:
            kek = kek128
        case .bits192:
            kek = kek192
        case .bits256:
            kek = kek256
        }

        guard let sharedSecret else {
            switch keySize {
            case .bits128:
                symmetricKey = .init(size: .bits128)
            case .bits192:
                symmetricKey = .init(size: .bits192)
            case .bits256:
                symmetricKey = .init(size: .bits256)
            }

            guard let wrappedKey = try? AES.KeyWrap.wrap(symmetricKey, using: kek) else {
                return nil
            }

            return wrappedKey
        }

        symmetricKey = .init(data: sharedSecret.keyPair.privateKey)

        guard let wrappedKey = try? AES.KeyWrap.wrap(symmetricKey, using: kek) else {
            return nil
        }

        return wrappedKey
    }

    func generateKeys(
        with numberOfSessions: UInt,
        for sharedSecrets: [SBRConfidential.SharedSecret]? = nil
    ) async -> [Data]? {
        guard
            sharedSecrets == nil,
            numberOfSessions != 0
        else {
            return nil
        }

        let generatedKeys = await withTaskGroup(
            of: Data?.self,
            returning: [Data].self
        ) { group in
            (0 ..< numberOfSessions).forEach { _ in
                group.addTask {
                    await self.generateKey()
                }
            }

            return await group
                .reduce(into: [Data?]()) { $0.append($1) }
                .compactMap { $0 }
        }

        return (generatedKeys.count == numberOfSessions) ? generatedKeys : nil
    }
}
