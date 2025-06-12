//
//  HeroesService.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

protocol HeroesServiceProtocol {
    func fetchMore(offset: Int) async throws -> [Character]
    func fetchCachedHeroes() throws -> [Character]
    func save(characters: [Character]) async throws
}

final class HeroesService: HeroesServiceProtocol {
    private let fetchUseCase: FetchHeroesUseCaseProtocol
    private let cache: CharacterCacheRepositoryProtocol

    init(
        fetchUseCase: FetchHeroesUseCaseProtocol = FetchHeroesUseCase(),
        cache: CharacterCacheRepositoryProtocol = CharacterCacheRepository()
    ) {
        self.fetchUseCase = fetchUseCase
        self.cache = cache
    }

    func fetchMore(offset: Int) async throws -> [Character] {
        try await fetchUseCase.fetch(offset: offset)
    }

    func fetchCachedHeroes() throws -> [Character] {
        try cache.fetchCachedHeroes()
    }

    func save(characters: [Character]) async throws {
        try await cache.save(characters: characters)
    }
}
