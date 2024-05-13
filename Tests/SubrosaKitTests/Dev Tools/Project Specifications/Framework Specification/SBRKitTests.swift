//
//  SBRKitTests.swift
//  SubrosaKit Tests
//
//  Created by Dimka Novikov on 13.05.2024.
//  Copyright © 2024 Lofticries Games. All rights reserved.
//


// MARK: Import section

import XCTest
@testable import SubrosaKit



// MARK: - SBRKitTests

final class SBRKitTests: XCTestCase {

    // MARK: - Tests

    func test_FrameworkVersionIsExists() {
        let sut = SBRKit.info

        let version = sut.version

        XCTAssertNotNil(version)
    }

    func test_FrameworkVersionIsNotEmpty() {
        let sut = SBRKit.info

        let version = sut.version
        let stringVersion = "\(version.major).\(version.minor).\(version.patch)"

        XCTAssertNotEqual(stringVersion, "0.0.0")
    }

    func test_FrameworkBuildIsExists() {
        let sut = SBRKit.info

        let build = sut.build

        XCTAssertNotNil(build)
    }

    func test_FrameworkBuildIsNotEmpty() {
        let sut = SBRKit.info

        let build = sut.build

        XCTAssertNotEqual(build, 0)
    }
}
