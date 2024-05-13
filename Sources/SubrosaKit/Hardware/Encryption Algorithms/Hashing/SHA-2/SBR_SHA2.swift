//
//  SBR_SHA2.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import CryptoKit
import Foundation



// MARK: - SBR_SHA2

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
final class SBR_SHA2 {

    // MARK: - Private properties

    private let hashValue: SBRConfidential.HashValue



    // MARK: - Init

    init(hashValue: SBRConfidential.HashValue) {
        self.hashValue = hashValue
    }



    // MARK: - Private properties

    private func hashString(_ plainText: String) async -> Data? {
        guard let data = plainText.data(using: .utf8) else {
            return nil
        }

        switch hashValue {
        case .bits256:
            return SHA256
                .hash(data: data)
                .compactMap { String(format: "%02x", $0) }
                .joined()
                .data(using: .utf8)
        case .bits384:
            return SHA384
                .hash(data: data)
                .compactMap { String(format: "%02x", $0) }
                .joined()
                .data(using: .utf8)
        case .bits512:
            return SHA512
                .hash(data: data)
                .compactMap { String(format: "%02x", $0) }
                .joined()
                .data(using: .utf8)
        }
    }
}



// MARK: - SBRConfidentable

extension SBR_SHA2: SBRConfidentable {

    // MARK: - Public methods

    func encrypt(propertySet: SBRConfidential.EncryptionPropertySet) async -> Data? {
        await hashString(propertySet.text)
    }

    func encrypt(propertySets: [SBRConfidential.EncryptionPropertySet]) async -> [Data]? {
        let hashedStrings = await withTaskGroup(
            of: (Data?, Int).self,
            returning: [Data].self
        ) { group in
            propertySets
                .enumerated()
                .forEach { (index, propertySet) in
                    group.addTask {
                        let hashedString = await self.encrypt(propertySet: propertySet)

                        return (hashedString, index)
                    }
                }

            return await group
                .reduce(into: [(Data?, Int)]()) { $0.append($1) }
                .sorted { $0.1 < $1.1 }
                .compactMap { $0.0 }
        }

        return (hashedStrings.count == propertySets.count) ? hashedStrings : nil
    }
}



// MARK: - SBRGeneratable

extension SBR_SHA2: SBRGeneratable { }
