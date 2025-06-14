//
//  MockFetchHeroesUseCase.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation
@testable import WallaMarvel

final class MockFetchHeroesUseCase: FetchHeroesUseCaseProtocol {
    var shouldReturnError = false
    var heroesToReturn: [Character] = []
    var cachedHeroes: [Character] = []
    
    func execute(offset: Int) async throws -> [Character] {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        try await Task.sleep(nanoseconds: 200_000_000)
        return Array(heroesToReturn.dropFirst(offset).prefix(20))
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        return cachedHeroes
    }
    
    func save(characters: [Character]) async throws {
        cachedHeroes = characters
    }
}
