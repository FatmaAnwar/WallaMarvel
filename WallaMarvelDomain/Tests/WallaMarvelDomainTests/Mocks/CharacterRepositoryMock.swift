//
//  CharacterRepositoryMock.swift
//  WallaMarvelDomain
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
@testable import WallaMarvelDomain

@MainActor

final class MockCharacterRepository: CharacterRepositoryProtocol {
    
    var stubbedCharacters: [Character] = []
    var fetchedOffset: Int?
    var savedCharacters: [Character]?
    var shouldThrow = false
    
    func fetchCharacters(offset: Int) async throws -> [Character] {
        if shouldThrow {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        fetchedOffset = offset
        return stubbedCharacters
    }
    
    func save(characters: [Character]) async throws {
        if shouldThrow {
            throw NSError(domain: "TestError", code: -2, userInfo: nil)
        }
        savedCharacters = characters
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        if shouldThrow {
            throw NSError(domain: "TestError", code: -3, userInfo: nil)
        }
        return stubbedCharacters
    }
}
