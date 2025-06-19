//
//  FailingContext.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 19/06/2025.
//

import Foundation
import WallaMarvelDomain
import WallaMarvelData

final class MockFailingCharacterCacheRepository: CharacterCacheRepositoryProtocol {
    enum FailingScenario {
        case saveError, fetchError
    }
    
    let scenario: FailingScenario
    
    init(scenario: FailingScenario) {
        self.scenario = scenario
    }
    
    func save(characters: [Character]) async throws {
        if scenario == .saveError {
            throw NSError(domain: "CoreData", code: 999)
        }
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        if scenario == .fetchError {
            throw NSError(domain: "CoreData", code: 888)
        }
        return []
    }
}
