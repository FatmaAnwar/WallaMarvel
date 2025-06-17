//
//  NetworkMonitoringProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation
import Combine

@MainActor
public protocol NetworkMonitoringProtocol: AnyObject {
    var isConnected: Bool { get }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

