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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
protocol SBRKeyGeneratable: AnyObject {

    // MARK: - Public methods

    func generateKey(for sharedSecret: SBRConfidential.SharedSecret?) async -> Data?

    func generateKeys(with numberOfSessions: UInt, for sharedSecrets: [SBRConfidential.SharedSecret]?) async -> [Data]?
}
