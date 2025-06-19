//
//  MockNetworkMonitor.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 19/06/2025.
//

import Foundation
import Combine
import WallaMarvelCore

@MainActor
final class MockNetworkMonitor: NetworkMonitoringProtocol {
    var isConnected: Bool = true
    var isConnectedSubject = PassthroughSubject<Bool, Never>()
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
}
