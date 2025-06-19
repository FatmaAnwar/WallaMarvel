//
//  CharacterCachePersistingServiceTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import WallaMarvelDomain
@testable import WallaMarvelData

@MainActor
final class CharacterCachePersistingServiceTests: XCTestCase {
    
    func test_persistIfNeeded_shouldFetchAndSave() async {
        // Given
        let repo = MockCharacterCacheRepository(
            scenario: .success,
            stubbedCharacters: [Character(id: 1, name: "Hulk", imageUrl: "img", description: "smash")]
        )
        let service = CharacterCachePersistingService(repository: repo)
        
        // When
        await service.persistIfNeeded()
        
        // Then
        XCTAssertTrue(repo.didCallFetch)
        XCTAssertTrue(repo.didCallSave)
    }
    
    func test_persistIfNeeded_whenFetchFails_shouldNotCrash() async {
        // Given
        let repo = MockCharacterCacheRepository(scenario: .failFetch)
        let service = CharacterCachePersistingService(repository: repo)
        
        // When
        await service.persistIfNeeded()
        
        // Then
        XCTAssertTrue(repo.didCallFetch)
        XCTAssertFalse(repo.didCallSave)
    }
    
    func test_persistIfNeeded_whenSaveFails_shouldNotCrash() async {
        // Given
        let repo = MockCharacterCacheRepository(
            scenario: .failSave,
            stubbedCharacters: [Character(id: 2, name: "Thor", imageUrl: "", description: "God")]
        )
        let service = CharacterCachePersistingService(repository: repo)
        
        // When
        await service.persistIfNeeded()
        
        // Then
        XCTAssertTrue(repo.didCallFetch)
        XCTAssertTrue(repo.didCallSave)
    }
    
    func test_persistIfNeeded_withEmptyCharacters_shouldStillCallSave() async {
        // Given
        let repo = MockCharacterCacheRepository(scenario: .success, stubbedCharacters: [])
        let service = CharacterCachePersistingService(repository: repo)
        
        // When
        await service.persistIfNeeded()
        
        // Then
        XCTAssertTrue(repo.didCallFetch)
        XCTAssertTrue(repo.didCallSave)
    }
}
