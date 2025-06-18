//
//  CharacterCachePersistingService.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation
import WallaMarvelDomain

@MainActor
protocol CharacterCachePersistingServiceProtocol {
    func persistIfNeeded() async
}

@MainActor
public final class CharacterCachePersistingService: CharacterCachePersistingServiceProtocol {
    private let repository: CharacterCacheRepositoryProtocol
    
    @MainActor
    public init(repository: CharacterCacheRepositoryProtocol = CharacterCacheRepository()) {
        self.repository = repository
    }
    
    public func persistIfNeeded() async {
        do {
            let characters = try repository.fetchCachedHeroes()
            try await repository.save(characters: characters)
        } catch {
            print("Persistence failed: \(error)")
        }
    }
}
