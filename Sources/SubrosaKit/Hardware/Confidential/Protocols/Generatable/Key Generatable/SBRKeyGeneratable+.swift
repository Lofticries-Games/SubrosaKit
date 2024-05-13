//
//  SBRKeyGeneratable+.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2023.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRKeyGeneratable+

extension SBRKeyGeneratable {

    // MARK: - Public methods

    func generateKey(for sharedSecret: SBRConfidential.SharedSecret? = nil) async -> Data? { nil }

    func generateKeys(with numberOfSessions: UInt = 10, for sharedSecrets: [SBRConfidential.SharedSecret]? = nil) async -> [Data]? { nil }
}
