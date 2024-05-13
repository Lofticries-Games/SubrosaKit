//
//  SBRKeyPairGeneratable+.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2023.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRKeyPairGeneratable+

extension SBRKeyPairGeneratable {

    // MARK: - Public methods

    func generateKeyPair() async -> SBRConfidential.KeyPair? { nil }

    func generateKeyPairs(with numberOfSessions: UInt = 10) async -> [SBRConfidential.KeyPair]? { nil }
}
