//
//  SBR_EdDSATests.swift
//  SubrosaKit Tests
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import XCTest
@testable import SubrosaKit



// MARK: - SBR_EdDSATests

final class SBR_EdDSATests: XCTestCase {

    // MARK: - Private properties

    private let sut = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))

    private let plainText = "Hello, 🌏!"



    // MARK: - Tests

    func test_EncryptAndDecryptStringIsNotNil() {
        executeAsyncTest { [self] in
            let dogPlainText = "woof-woof-woof"
            let catPlainText = "meow-meow-meow"

            let catKeyPair = await sut.generateKeyPair()!
            let dogKeyPair = await sut.generateKeyPair()!

            let salt = await sut.generateSalt()!

            let catSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: catKeyPair.privateKey,
                        publicKey: dogKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            let dogSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: dogKeyPair.privateKey,
                        publicKey: catKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            let catEncryptedData = await sut.encrypt(propertySet: .init(text: catPlainText, key: catSymmetricKey))!
            let dogEncryptedData = await sut.encrypt(propertySet: .init(text: dogPlainText, key: dogSymmetricKey))!

            let catDecryptedText = await sut.decrypt(propertySet: .init(data: dogEncryptedData, key: catSymmetricKey))!
            let dogDecryptedText = await sut.decrypt(propertySet: .init(data: catEncryptedData, key: dogSymmetricKey))!

            XCTAssertNotNil(catDecryptedText)
            XCTAssertNotNil(dogDecryptedText)
        }
    }

    func test_EncryptAndDecryptStringIsEqualToPlainText() {
        executeAsyncTest { [self] in
            let dogPlainText = "woof-woof-woof"
            let catPlainText = "meow-meow-meow"

            let catKeyPair = await sut.generateKeyPair()!
            let dogKeyPair = await sut.generateKeyPair()!

            let salt = await sut.generateSalt()!

            let catSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: catKeyPair.privateKey,
                        publicKey: dogKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            let dogSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: dogKeyPair.privateKey,
                        publicKey: catKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            let catEncryptedData = await sut.encrypt(propertySet: .init(text: catPlainText, key: catSymmetricKey))!
            let dogEncryptedData = await sut.encrypt(propertySet: .init(text: dogPlainText, key: dogSymmetricKey))!

            let catDecryptedText = await sut.decrypt(propertySet: .init(data: dogEncryptedData, key: catSymmetricKey))!
            let dogDecryptedText = await sut.decrypt(propertySet: .init(data: catEncryptedData, key: dogSymmetricKey))!

            XCTAssertEqual(catDecryptedText, dogPlainText)
            XCTAssertEqual(dogDecryptedText, catPlainText)
        }
    }

    func test_EncryptAndDecryptStringsIsEqualToPlainTexts() {
        executeAsyncTest { [self] in
            let dogPlainTexts = ["woof", "woof", "woof"]
            let catPlainTexts = ["meow", "meow", "meow"]

            let catKeyPairs = await sut.generateKeyPairs(with: UInt(catPlainTexts.count))!
            let dogKeyPairs = await sut.generateKeyPairs(with: UInt(dogPlainTexts.count))!

            let salts = await sut.generateSalts(with: UInt(dogPlainTexts.count))!

            var catSymmetricKeys = Array<Data>.init(repeating: .init(), count: catKeyPairs.count)
            var dogSymmetricKeys = Array<Data>.init(repeating: .init(), count: dogKeyPairs.count)

            for index in (0 ..< 3) {
                catSymmetricKeys[index] = await sut.generateKey(
                    for: .init(
                        keyPair: .init(
                            privateKey: catKeyPairs[index].privateKey,
                            publicKey: dogKeyPairs[index].publicKey!
                        ),
                        salt: salts[index]
                    )
                )!

                dogSymmetricKeys[index] = await sut.generateKey(
                    for: .init(
                        keyPair: .init(
                            privateKey: dogKeyPairs[index].privateKey,
                            publicKey: catKeyPairs[index].publicKey!
                        ),
                        salt: salts[index]
                    )
                )!
            }

            var dogPropertySets1: [SBRConfidential.EncryptionPropertySet] = []
            var catPropertySets1: [SBRConfidential.EncryptionPropertySet] = []

            dogPlainTexts.enumerated().forEach { (index, text) in
                dogPropertySets1.append(.init(text: dogPlainTexts[index], key: dogSymmetricKeys[index]))
            }

            catPlainTexts.enumerated().forEach { (index, text) in
                catPropertySets1.append(.init(text: catPlainTexts[index], key: catSymmetricKeys[index]))
            }

            let dogEncryptedDatas = await sut.encrypt(propertySets: dogPropertySets1)
            let catEncryptedDatas = await sut.encrypt(propertySets: catPropertySets1)

            var dogPropertySets2: [SBRConfidential.DecryptionPropertySet] = []
            var catPropertySets2: [SBRConfidential.DecryptionPropertySet] = []

            dogEncryptedDatas!.enumerated().forEach { (index, data) in
                dogPropertySets2.append(.init(data: data, key: dogSymmetricKeys[index]))
            }

            catEncryptedDatas!.enumerated().forEach { (index, data) in
                catPropertySets2.append(.init(data: data, key: catSymmetricKeys[index]))
            }

            let catDecryptedTexts = await sut.decrypt(propertySets: dogPropertySets2)
            let dogDecryptedTexts = await sut.decrypt(propertySets: catPropertySets2)

            catDecryptedTexts!.enumerated().forEach { (index, text) in
                XCTAssertEqual(text, dogPlainTexts[index])
            }

            dogDecryptedTexts!.enumerated().forEach { (index, text) in
                XCTAssertEqual(text, catPlainTexts[index])
            }
        }
    }

    func test_GenerateKeyIsNotNil() {
        executeAsyncTest { [self] in
            let catKeyPair = await sut.generateKeyPair()!
            let dogKeyPair = await sut.generateKeyPair()!

            let salt = await sut.generateSalt()!

            let catSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: catKeyPair.privateKey,
                        publicKey: dogKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            let dogSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: dogKeyPair.privateKey,
                        publicKey: catKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            XCTAssertNotNil(catSymmetricKey)
            XCTAssertNotNil(dogSymmetricKey)
        }
    }

    func test_GenerateKeyIsNotEmpty() {
        executeAsyncTest { [self] in
            let catKeyPair = await sut.generateKeyPair()!
            let dogKeyPair = await sut.generateKeyPair()!

            let salt = await sut.generateSalt()!

            let catSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: catKeyPair.privateKey,
                        publicKey: dogKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            let dogSymmetricKey = await sut.generateKey(
                for: .init(
                    keyPair: .init(
                        privateKey: dogKeyPair.privateKey,
                        publicKey: catKeyPair.publicKey!
                    ),
                    salt: salt
                )
            )

            XCTAssertNotEqual(String(data: catSymmetricKey!, encoding: .utf16)!, "")
            XCTAssertNotEqual(String(data: dogSymmetricKey!, encoding: .utf16)!, "")
        }
    }

    func test_GenerateKeysIsEquals() {
        executeAsyncTest { [self] in
            let catKeyPairs = await sut.generateKeyPairs()!
            let dogKeyPairs = await sut.generateKeyPairs()!

            let salts = await sut.generateSalts()!

            var catSymmetricKeys = Array<Data>.init(repeating: .init(), count: catKeyPairs.count)
            var dogSymmetricKeys = Array<Data>.init(repeating: .init(), count: dogKeyPairs.count)

            for index in (0 ..< catKeyPairs.count) {
                catSymmetricKeys[index] = await sut.generateKey(
                    for: .init(
                        keyPair: .init(
                            privateKey: catKeyPairs[index].privateKey,
                            publicKey: dogKeyPairs[index].publicKey
                        ),
                        salt: salts[index]
                    )
                )!

                dogSymmetricKeys[index] = await sut.generateKey(
                    for: .init(
                        keyPair: .init(
                            privateKey: dogKeyPairs[index].privateKey,
                            publicKey: catKeyPairs[index].publicKey
                        ),
                        salt: salts[index]
                    )
                )!
            }

            catSymmetricKeys
                .enumerated()
                .forEach { (index, catSymmetricKey) in
                    XCTAssertEqual(catSymmetricKey, dogSymmetricKeys[index])
                }
        }
    }

    func test_GenerateKeyPairIsNotNil() {
        executeAsyncTest { [self] in
            let keyPair = await sut.generateKeyPair()

            XCTAssertNotNil(keyPair)
        }
    }

    func test_GenerateKeyPairIsNotEmpty() {
        executeAsyncTest { [self] in
            let keyPair = await sut.generateKeyPair()

            XCTAssertNotEqual(String(data: keyPair!.privateKey, encoding: .utf16)!, "")
            XCTAssertNotEqual(String(data: keyPair!.publicKey!, encoding: .utf16)!, "")
        }
    }

    func test_GenerateKeyPairsIsNotNil() {
        executeAsyncTest { [self] in
            let keyPairs = await sut.generateKeyPairs()

            XCTAssertNotNil(keyPairs)
        }
    }

    func test_GenerateKeyPairsIsNotEmpty() {
        executeAsyncTest { [self] in
            let keyPairs = await sut.generateKeyPairs()

            keyPairs!.forEach { keyPair in
                XCTAssertNotEqual(String(data: keyPair.privateKey, encoding: .utf16)!, "")
                XCTAssertNotEqual(String(data: keyPair.publicKey!, encoding: .utf16)!, "")
            }
        }
    }

    func test_GenerateSaltIsNotNil() {
        executeAsyncTest { [self] in
            let salt = await sut.generateSalt()

            XCTAssertNotNil(salt)
        }
    }

    func test_GenerateSaltIsNotEmpty() {
        executeAsyncTest { [self] in
            let salt = await sut.generateSalt()

            XCTAssertNotEqual(String(data: salt!, encoding: .utf8)!, "")
        }
    }

    func test_GenerateSaltsIsNotNil() {
        executeAsyncTest { [self] in
            let salts = await sut.generateSalts()

            XCTAssertNotNil(salts)
        }
    }

    func test_GenerateSaltsIsNotEmpty() {
        executeAsyncTest { [self] in
            let salts = await sut.generateSalts()

            salts!.forEach { salt in
                XCTAssertNotEqual(String(data: salt, encoding: .utf8)!, "")
            }
        }
    }
}
