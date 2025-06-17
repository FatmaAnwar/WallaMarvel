//
//  CharacterCacheRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 11/06/2025.
//

import Foundation
import CoreData
import WallaMarvelDomain

final class CharacterCacheRepository: CharacterCacheRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func save(characters: [Character]) async throws {
        try clearCache()
        
        for character in characters {
            let cdCharacter = CDCharacter(context: context)
            cdCharacter.id = Int64(character.id)
            cdCharacter.name = character.name
            cdCharacter.desc = character.description
            cdCharacter.imageUrl = character.imageUrl
        }
        
        try context.save()
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        let request: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
        let results = try context.fetch(request)
        
        return results.map {
            Character(
                id: Int($0.id),
                name: ($0.name?.isEmpty ?? true) ? "Unknown" : $0.name!,
                imageUrl: $0.imageUrl ?? "",
                description: $0.desc ?? ""
            )
        }
    }
    
    func clearCache() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
        
        if context.persistentStoreCoordinator?.persistentStores.first?.type == NSInMemoryStoreType {
            let objects = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for object in objects {
                context.delete(object)
            }
        } else {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
        }
        
        try context.save()
    }
}
