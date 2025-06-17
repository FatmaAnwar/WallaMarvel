//
//  AppEntry.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import UIKit
import Kingfisher

enum UIType {
    case uikit, swiftui
}

@available(iOS 15.0, *)
final class AppEntry {
    
    static func start(using windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        configureInitialUI(using: navigationController)
        configureImageCache()
        
        return window
    }
    
    private static func configureInitialUI(using navigationController: UINavigationController) {
        SwiftUIHeroesCoordinator(navigationController: navigationController).start()
    }
    
    private static func configureImageCache() {
        let cache = ImageCache.default
        cache.diskStorage.config.expiration = .days(7)
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        cache.memoryStorage.config.countLimit = 100
    }
}
