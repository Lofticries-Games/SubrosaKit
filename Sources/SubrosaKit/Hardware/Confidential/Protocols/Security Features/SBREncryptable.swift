//
//  SBREncryptable.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBREncryptable

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
protocol SBREncryptable: AnyObject {

    // MARK: - Public methods

    func encrypt(propertySet: SBRConfidential.EncryptionPropertySet) async -> Data?

    func encrypt(propertySets: [SBRConfidential.EncryptionPropertySet]) async -> [Data]?
}
