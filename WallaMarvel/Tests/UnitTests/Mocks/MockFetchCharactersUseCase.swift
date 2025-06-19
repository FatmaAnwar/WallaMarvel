//
//  MockFetchCharactersUseCase.swift
//  WallaMarvelTests
//
//  Created by Fatma Anwar on 19/06/2025.
//

import Foundation
import WallaMarvelDomain

@MainActor
final class MockFetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    var shouldThrow = false
    var stubbedCharacters: [Character] = []
    var stubbedCachedCharacters: [Character] = []
    var saveCalled = false

    func execute(offset: Int) async throws -> [Character] {
        if shouldThrow {
            throw NSError(domain: "TestError", code: 1)
        }
        return stubbedCharacters
    }

    func save(characters: [Character]) async throws {
        saveCalled = true
    }

    func fetchCachedHeroes() throws -> [Character] {
        return stubbedCachedCharacters
    }
}
