//
//  SBRConfidentable.swift
//  SubrosaKit
//
//  Created by Dimka Novikov on 13.05.2023.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import Foundation



// MARK: - SBRConfidentable

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
typealias SBRConfidentable = SBREncryptable & SBRDecryptable
