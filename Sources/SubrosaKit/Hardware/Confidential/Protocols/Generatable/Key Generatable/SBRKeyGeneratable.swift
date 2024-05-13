//
//  SBRKeyGeneratable.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRKeyGeneratable

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
protocol SBRKeyGeneratable: AnyObject {

    // MARK: - Public methods

    func generateKey(for sharedSecret: SBRConfidential.SharedSecret?) async -> Data?

    func generateKeys(with numberOfSessions: UInt, for sharedSecrets: [SBRConfidential.SharedSecret]?) async -> [Data]?
}
