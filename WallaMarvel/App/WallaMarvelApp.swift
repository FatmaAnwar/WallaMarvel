//
//  WallaMarvelApp.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct WallaMarvelApp: App {
    private let lifecycleObserver = AppLifecycleObserver()

    var body: some Scene {
        WindowGroup {
            HeroesListView()
        }
    }
}

