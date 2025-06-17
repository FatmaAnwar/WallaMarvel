//
//  WallaMarvelApp.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct WallaMarvelApp: App {
    private let lifecycleObserver = AppLifecycleObserver()
    private let coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
