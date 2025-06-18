//
//  NetworkMonitorTests.swift
//  WallaMarvelCore
//
//  Created by Fatma Anwar on 18/06/2025.
//

import XCTest
import Combine
@testable import WallaMarvelCore

@MainActor
final class NetworkMonitorTests: XCTestCase {

    func test_initialConnectionIsTrue() {
        let monitor = NetworkMonitor.shared
        XCTAssertTrue(monitor.isConnected)
    }

    func test_isConnectedPublisher_emitsValue() {
        let monitor = NetworkMonitor.shared
        let expectation = XCTestExpectation(description: "Publisher emits change")
        var receivedValues = [Bool]()

        let cancellable = monitor.isConnectedPublisher
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count > 0 {
                    expectation.fulfill()
                }
            }

        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(receivedValues.isEmpty)
        cancellable.cancel()
    }
}
