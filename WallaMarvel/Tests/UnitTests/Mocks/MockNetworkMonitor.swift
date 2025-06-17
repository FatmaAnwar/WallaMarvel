//
//  MockNetworkMonitor.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation
import Combine
@testable import WallaMarvel

final class MockNetworkMonitor: NetworkMonitoringProtocol {
    var isConnected: Bool = true {
        didSet {
            isConnectedSubject.send(isConnected)
        }
    }
    
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
}
