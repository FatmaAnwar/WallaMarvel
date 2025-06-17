//
//  FetchCharactersUseCase.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation
import WallaMarvelDomain

final class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol
    
    init(repository: CharacterRepositoryProtocol = CharacterRepository()) {
        self.repository = repository
    }
    
    func execute(offset: Int) async throws -> [Character] {
        try await repository.fetchCharacters(offset: offset)
    }
    
    func save(characters: [Character]) async throws {
        try await repository.save(characters: characters)
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        try repository.fetchCachedHeroes()
    }
}
