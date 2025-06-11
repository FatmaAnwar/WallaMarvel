//
//  CharacterCacheRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 11/06/2025.
//

import Foundation
import CoreData

protocol CharacterCacheRepositoryProtocol {
    func save(characters: [Character]) async throws
    func fetchCachedHeroes() throws -> [Character]
    func clearCache() throws
}

final class CharacterCacheRepository: CharacterCacheRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func save(characters: [Character]) async throws {
        try clearCache() // Optional: clear old cache before saving new
        
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
                name: $0.name ?? "Unknown",
                imageUrl: $0.imageUrl ?? "",
                description: $0.desc ?? ""
            )
        }
    }
    
    func clearCache() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
