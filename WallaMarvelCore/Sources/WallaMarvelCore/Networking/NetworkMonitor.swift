//
//  NetworkMonitor.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 11/06/2025.
//

import Network
import Combine

@MainActor
public final class NetworkMonitor: ObservableObject, NetworkMonitoringProtocol {
    public static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published public private(set) var isConnected: Bool = true
    
    public var isConnectedPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
