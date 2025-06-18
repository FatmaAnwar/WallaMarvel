//
//  AppLifecycleObserver.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import SwiftUI
import Combine
import WallaMarvelData

@MainActor
final class AppLifecycleObserver {
    private var cancellables = Set<AnyCancellable>()
    private let cacheService = CharacterCachePersistingService()
    
    init() {
        observeLifecycle()
    }
    
    private func observeLifecycle() {
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification))
            .sink { [weak self] _ in
                Task {
                    await self?.persistCache()
                }
            }
            .store(in: &cancellables)
    }
    
    private func persistCache() async {
        await cacheService.persistIfNeeded()
        CoreDataStack.shared.saveContext()
    }
}
