//
//  MockCharacterCacheRepository.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import WallaMarvelDomain
import WallaMarvelData

@MainActor
final class MockCharacterCacheRepository: CharacterCacheRepositoryProtocol {
    
    enum Scenario {
        case success
        case failFetch
        case failSave
    }
    
    var scenario: Scenario = .success
    var stubbedCharacters: [Character] = []
    var savedCharacters: [Character] = []
    
    var didCallFetch = false
    var didCallSave = false
    
    init(scenario: Scenario = .success, stubbedCharacters: [Character] = []) {
        self.scenario = scenario
        self.stubbedCharacters = stubbedCharacters
    }
    
    func save(characters: [Character]) async throws {
        didCallSave = true
        if scenario == .failSave {
            throw NSError(domain: "CoreData", code: 999)
        }
        savedCharacters = characters
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        didCallFetch = true
        if scenario == .failFetch {
            throw NSError(domain: "CoreData", code: 888)
        }
        return stubbedCharacters
    }
}
