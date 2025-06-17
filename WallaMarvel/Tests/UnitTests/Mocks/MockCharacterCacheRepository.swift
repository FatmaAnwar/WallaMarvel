//
//  MockCharacterCacheRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
@testable import WallaMarvel

final class MockCharacterCacheRepository: CharacterCacheRepositoryProtocol {
    var cachedCharacters: [Character] = []
    var savedCharacters: [Character] = []
    var shouldThrow: Bool = false
    
    func fetchCachedHeroes() throws -> [Character] {
        if shouldThrow {
            throw URLError(.cannotLoadFromNetwork)
        }
        return cachedCharacters
    }
    
    func save(characters: [Character]) throws {
        if shouldThrow {
            throw URLError(.cannotCreateFile)
        }
        savedCharacters = characters
    }
}
