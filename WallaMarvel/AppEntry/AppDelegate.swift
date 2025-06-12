import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let cacheService = CharacterCachePersistingService()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.persistCachedHeroes()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.persistCachedHeroes()
        }
        
        return true
    }
    
    private func persistCachedHeroes() {
        cacheService.persistIfNeeded()
        CoreDataStack.shared.saveContext()
    }
}

