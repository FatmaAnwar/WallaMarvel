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
        // Given
        let monitor = NetworkMonitor.shared
        
        // When
        let isConnected = monitor.isConnected
        
        // Then
        XCTAssertTrue(isConnected)
    }
    
    func test_isConnectedPublisher_emitsValue() {
        // Given
        let monitor = NetworkMonitor.shared
        let expectation = XCTestExpectation(description: "Publisher emits value")
        var received = [Bool]()
        
        // When
        let cancellable = monitor.isConnectedPublisher
            .sink { value in
                received.append(value)
                if !received.isEmpty {
                    expectation.fulfill()
                }
            }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(received.isEmpty)
        cancellable.cancel()
    }
}
