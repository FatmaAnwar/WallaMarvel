//
//  MockMarvelRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation
@testable import WallaMarvel

final class MockMarvelRepository: MarvelRepositoryProtocol {
    var shouldThrow = false
    var heroesToReturn: [Character] = []
    var cachedHeroes: [Character] = []
    var savedHeroes: [Character] = []
    
    func fetchCharacters(offset: Int) async throws -> [Character] {
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return heroesToReturn
    }
    
    func save(characters: [Character]) async throws {
        if shouldThrow { throw URLError(.badServerResponse) }
        savedHeroes = characters
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return cachedHeroes
    }
}
