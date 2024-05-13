//
//  SBRGeneratable.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRGeneratable

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
typealias SBRGeneratable = SBRKeyGeneratable & SBRKeyPairGeneratable & SBRSaltGeneratable
