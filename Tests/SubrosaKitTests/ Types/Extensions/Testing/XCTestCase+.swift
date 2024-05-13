//
//  XCTestCase+.swift
//  SubrosaKit Tests
//
//  Created by Dimka Novikov on 12.11.2023.
//  Copyright © 2023 Exhausted Reality. All rights reserved.
//


// MARK: Import section

import XCTest



// MARK: - XCTestCase+

extension XCTestCase {

    // MARK: - Public methods

    func executeAsyncTest(
        timeout: TimeInterval = 10,
        _ body: @escaping () async throws -> Void,
        _ name: String = #function,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        var thrownError: Error?

        let errorHandler = { thrownError = $0 }

        let expectation = expectation(description: name)

        Task {
            do {
                try await body()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        if let thrownError {
            XCTFail("Async error thrown: \(thrownError)", file: file, line: line)
        }
    }
}

