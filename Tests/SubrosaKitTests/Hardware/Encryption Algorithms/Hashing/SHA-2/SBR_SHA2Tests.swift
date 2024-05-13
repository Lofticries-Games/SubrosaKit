//
//  SBR_SHA2Tests.swift
//  SubrosaKit Tests
//
//  Created by Dimka Novikov on 12.11.2023.
//  Copyright © 2023 Exhausted Reality. All rights reserved.
//


// MARK: Import section

import XCTest
@testable import SubrosaKit



// MARK: - SBR_SHA2Tests

final class SBR_SHA2Tests: XCTestCase {

    // MARK: - Private properties

    private let sut256 = SBRConfidential(with: .sha2(hashValue: .bits256))

    private let sut384 = SBRConfidential(with: .sha2(hashValue: .bits384))

    private let sut512 = SBRConfidential(with: .sha2(hashValue: .bits512))

    private let plainText = "Hello, 🌏!"



    // MARK: - Tests

    func test_EncryptStringWith256BitIsNotNil() {
        executeAsyncTest { [self] in
            let encryptedData = await sut256.encrypt(propertySet: .init(text: self.plainText))

            XCTAssertNotNil(encryptedData)
        }
    }

    func test_EncryptStringWith256BitIsNotEmpty() {
        executeAsyncTest { [self] in
            let encryptedData = await sut256.encrypt(propertySet: .init(text: self.plainText))!

            let hashedString = String(data: encryptedData, encoding: .utf8)!

            XCTAssertNotEqual(hashedString, "")
        }
    }

    func test_DecryptStringWith256BitIsNil() {
        executeAsyncTest { [self] in
            let decryptedText = await sut256.decrypt(propertySet: .init(data: self.plainText.data(using: .utf8)!))

            XCTAssertNil(decryptedText)
        }
    }

    func test_EncryptStringWith384BitIsNotNil() {
        executeAsyncTest { [self] in
            let encryptedData = await sut384.encrypt(propertySet: .init(text: self.plainText))

            XCTAssertNotNil(encryptedData)
        }
    }

    func test_EncryptStringWith384BitIsNotEmpty() {
        executeAsyncTest { [self] in
            let encryptedData = await sut384.encrypt(propertySet: .init(text: self.plainText))!

            let hashedString = String(data: encryptedData, encoding: .utf8)!

            XCTAssertNotEqual(hashedString, "")
        }
    }

    func test_DecryptStringWith384BitIsNil() {
        executeAsyncTest { [self] in
            let decryptedText = await sut384.decrypt(propertySet: .init(data: self.plainText.data(using: .utf8)!))

            XCTAssertNil(decryptedText)
        }
    }

    func test_EncryptStringWith512BitIsNotNil() {
        executeAsyncTest { [self] in
            let encryptedData = await sut512.encrypt(propertySet: .init(text: self.plainText))

            XCTAssertNotNil(encryptedData)
        }
    }

    func test_EncryptStringWith512BitIsNotEmpty() {
        executeAsyncTest { [self] in
            let encryptedData = await sut512.encrypt(propertySet: .init(text: self.plainText))!

            let hashedString = String(data: encryptedData, encoding: .utf8)!

            XCTAssertNotEqual(hashedString, "")
        }
    }

    func test_DecryptStringWith512BitIsNil() {
        executeAsyncTest { [self] in
            let decryptedText = await sut512.decrypt(propertySet: .init(data: self.plainText.data(using: .utf8)!))

            XCTAssertNil(decryptedText)
        }
    }

    func test_EncryptStringsIsNotEmpty() {
        executeAsyncTest { [self] in
            let propertySets: [SBRConfidential.EncryptionPropertySet] = [
                .init(text: "Hello"),
                .init(text: "🌏")
            ]

            let encryptedDatas = await sut512.encrypt(propertySets: propertySets)

            XCTAssertNotNil(encryptedDatas)

            encryptedDatas?.forEach { encryptedData in
                XCTAssertNotNil(encryptedData)
            }
        }
    }

    func test_DecryptStringsIsNil() {
        executeAsyncTest { [self] in
            let propertySets: [SBRConfidential.DecryptionPropertySet] = [
                .init(data: "Hello".data(using: .utf8)!),
                .init(data: "🌏".data(using: .utf8)!)
            ]

            let decryptedTexts = await sut512.decrypt(propertySets: propertySets)

            XCTAssertNil(decryptedTexts)
        }
    }

    func test_GenerateKeyIsNil() {
        executeAsyncTest { [self] in
            let key = await sut512.generateKey()

            XCTAssertNil(key)
        }
    }

    func test_GenerateKeysIsNil() {
        executeAsyncTest { [self] in
            let keys = await sut512.generateKeys()

            XCTAssertNil(keys)
        }
    }

    func test_GenerateKeyPairIsNil() {
        executeAsyncTest { [self] in
            let keyPair = await sut512.generateKeyPair()

            XCTAssertNil(keyPair)
        }
    }

    func test_GenerateKeyPairsIsNil() {
        executeAsyncTest { [self] in
            let keyPairs = await sut512.generateKeyPairs()

            XCTAssertNil(keyPairs)
        }
    }

    func test_GenerateSaltIsNil() {
        executeAsyncTest { [self] in
            let salt = await sut512.generateSalt()

            XCTAssertNil(salt)
        }
    }

    func test_GenerateSaltsIsNil() {
        executeAsyncTest { [self] in
            let salts = await sut512.generateSalts()

            XCTAssertNil(salts)
        }
    }
}
