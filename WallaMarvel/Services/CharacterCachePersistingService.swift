//
//  CharacterCachePersistingService.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

protocol CharacterCachePersistingServiceProtocol {
    func persistIfNeeded()
}

final class CharacterCachePersistingService: CharacterCachePersistingServiceProtocol {
    private let repository: CharacterCacheRepositoryProtocol
    
    init(repository: CharacterCacheRepositoryProtocol = CharacterCacheRepository()) {
        self.repository = repository
    }
    
    func persistIfNeeded() {
        Task {
            let characters = try? repository.fetchCachedHeroes()
            if let characters = characters {
                try? await repository.save(characters: characters)
            }
        }
    }
}
