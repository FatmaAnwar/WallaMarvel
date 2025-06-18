//
//  CoreDataStack.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 11/06/2025.
//

import Foundation
import CoreData

@MainActor
public final class CoreDataStack {
    public static let shared = CoreDataStack()
    
    private init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: "WallaMarvel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model from WallaMarvelData package")
        }
        
        let container = NSPersistentContainer(name: "WallaMarvel", managedObjectModel: model)
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save CoreData context: \(error)")
            }
        }
    }
}
