//
//  SBR_AESTests.swift
//  SubrosaKit Tests
//
//  Created by Dimka Novikov on 12.11.2023.
//  Copyright © 2023 Exhausted Reality. All rights reserved.
//


// MARK: Import section

import XCTest
@testable import SubrosaKit



// MARK: - SBR_AESTests

final class SBR_AESTests: XCTestCase {

    // MARK: - Private properties

    private let sut128 = SBRConfidential(with: .aes(keySize: .bits128))

    private let sut192 = SBRConfidential(with: .aes(keySize: .bits192))

    private let sut256 = SBRConfidential(with: .aes(keySize: .bits256))

    private let plainText = "Hello, 🌏!"



    // MARK: - Tests

    func test_EncryptAndDecryptStringWith128BitIsNotNil() {
        executeAsyncTest { [self] in
            let key = await sut128.generateKey()

            let encryptedData = await sut128.encrypt(propertySet: .init(text: self.plainText, key: key))
            XCTAssertNotNil(encryptedData)

            let decryptedText = await sut128.decrypt(propertySet: .init(data: encryptedData!, key: key))!
            XCTAssertNotNil(decryptedText)
        }
    }

    func test_EncryptAndDecryptStringWith128BitIsEqualToPlainText() {
        executeAsyncTest { [self] in
            let key = await sut128.generateKey()

            let encryptedData = await sut128.encrypt(propertySet: .init(text: self.plainText, key: key))
            XCTAssertNotNil(encryptedData)

            let decryptedText = await sut128.decrypt(propertySet: .init(data: encryptedData!, key: key))
            XCTAssertNotNil(decryptedText)

            XCTAssertEqual(decryptedText!, self.plainText)
        }
    }

    func test_EncryptAndDecryptStringWith192BitIsNotNil() {
        executeAsyncTest { [self] in
            let key = await sut192.generateKey()

            let encryptedData = await sut192.encrypt(propertySet: .init(text: self.plainText, key: key))
            XCTAssertNotNil(encryptedData)

            let decryptedText = await sut192.decrypt(propertySet: .init(data: encryptedData!, key: key))!
            XCTAssertNotNil(decryptedText)
        }
    }

    func test_EncryptAndDecryptStringWith192BitIsEqualToPlainText() {
        executeAsyncTest { [self] in
            let key = await sut192.generateKey()

            let encryptedData = await sut192.encrypt(propertySet: .init(text: self.plainText, key: key))
            XCTAssertNotNil(encryptedData)

            let decryptedText = await sut192.decrypt(propertySet: .init(data: encryptedData!, key: key))
            XCTAssertNotNil(decryptedText)

            XCTAssertEqual(decryptedText!, self.plainText)
        }
    }

    func test_EncryptAndDecryptStringWith256BitIsNotNil() {
        executeAsyncTest { [self] in
            let key = await sut256.generateKey()

            let encryptedData = await sut256.encrypt(propertySet: .init(text: self.plainText, key: key))
            XCTAssertNotNil(encryptedData)

            let decryptedText = await sut256.decrypt(propertySet: .init(data: encryptedData!, key: key))!
            XCTAssertNotNil(decryptedText)
        }
    }

    func test_EncryptAndDecryptStringWith256BitIsEqualToPlainText() {
        executeAsyncTest { [self] in
            let key = await sut256.generateKey()

            let encryptedData = await sut256.encrypt(propertySet: .init(text: self.plainText, key: key))
            XCTAssertNotNil(encryptedData)

            let decryptedText = await sut256.decrypt(propertySet: .init(data: encryptedData!, key: key))
            XCTAssertNotNil(decryptedText)

            XCTAssertEqual(decryptedText!, self.plainText)
        }
    }

    func test_EncryptAndDecryptStringsIsEqualToPlainTexts() {
        executeAsyncTest { [self] in
            let plainTexts = ["Hello", "🌏"]

            let keys = await sut256.generateKeys(with: 2)!

            let propertySets1: [SBRConfidential.EncryptionPropertySet] = [
                .init(text: plainTexts[0], key: keys[0]),
                .init(text: plainTexts[1], key: keys[1])
            ]

            let encryptedDatas = await sut256.encrypt(propertySets: propertySets1)
            XCTAssertNotNil(encryptedDatas)

            let propertySets2: [SBRConfidential.DecryptionPropertySet] = [
                .init(data: encryptedDatas![0], key: keys[0]),
                .init(data: encryptedDatas![1], key: keys[1])
            ]

            let decryptedTexts = await sut256.decrypt(propertySets: propertySets2)

            XCTAssertNotNil(decryptedTexts)

            decryptedTexts!.enumerated().forEach { (index, text) in
                XCTAssertEqual(plainTexts[index], text)
            }
        }
    }

    func test_GenerateKeyIsNotNil() {
        executeAsyncTest { [self] in
            let key = await sut256.generateKey()

            XCTAssertNotNil(key)
        }
    }

    func test_GenerateKeyIsNotEmpty() {
        executeAsyncTest { [self] in
            let key = await sut256.generateKey()

            XCTAssertNotEqual(String(data: key!, encoding: .utf16)!, "")
        }
    }

    func test_GenerateKeysIsNotNil() {
        executeAsyncTest { [self] in
            let keys = await sut256.generateKeys()

            XCTAssertNotNil(keys)
        }
    }

    func test_GenerateKeysIsNotEmpty() {
        executeAsyncTest { [self] in
            let keys = await sut256.generateKeys(with: 2)

            keys!.forEach { key in
                XCTAssertNotEqual(String(data: key, encoding: .utf16)!, "")
            }
        }
    }

    func test_GenerateKeyPairIsNil() {
        executeAsyncTest { [self] in
            let keyPair = await sut256.generateKeyPair()

            XCTAssertNil(keyPair)
        }
    }

    func test_GenerateKeyPairsIsNil() {
        executeAsyncTest { [self] in
            let keyPairs = await sut256.generateKeyPairs()

            XCTAssertNil(keyPairs)
        }
    }

    func test_GenerateSaltIsNil() {
        executeAsyncTest { [self] in
            let salt = await sut256.generateSalt()

            XCTAssertNil(salt)
        }
    }

    func test_GenerateSaltsIsNil() {
        executeAsyncTest { [self] in
            let salts = await sut256.generateSalts()

            XCTAssertNil(salts)
        }
    }
}
