//
//  FetchCharactersUseCase.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation
import WallaMarvelDomain

@MainActor
public final class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol
    
    public init(
        repository: CharacterRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    public func execute(offset: Int) async throws -> [Character] {
        try await repository.fetchCharacters(offset: offset)
    }
    
    public func save(characters: [Character]) async throws {
        try await repository.save(characters: characters)
    }
    
    @MainActor
    public func fetchCachedHeroes() throws -> [Character] {
        try repository.fetchCachedHeroes()
    }
}
