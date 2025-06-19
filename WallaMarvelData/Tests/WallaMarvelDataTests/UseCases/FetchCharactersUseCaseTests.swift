//
//  FetchCharactersUseCaseTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import WallaMarvelCore
import WallaMarvelDomain
@testable import WallaMarvelData

@MainActor
final class FetchCharactersUseCaseTests: XCTestCase {
    
    final class MockRepo: CharacterRepositoryProtocol {
        var shouldThrow = false
        var stubbedCharacters: [Character] = []
        var receivedSavedCharacters: [Character] = []
        
        func fetchCharacters(offset: Int) async throws -> [Character] {
            if shouldThrow { throw NSError(domain: "TestError", code: 1) }
            return stubbedCharacters
        }
        
        func save(characters: [Character]) async throws {
            if shouldThrow { throw NSError(domain: "TestError", code: 2) }
            receivedSavedCharacters = characters
        }
        
        func fetchCachedHeroes() throws -> [Character] {
            if shouldThrow { throw NSError(domain: "TestError", code: 3) }
            return stubbedCharacters
        }
    }
    
    func test_execute_whenFetchSucceeds_shouldReturnCharacters() async throws {
        // Given
        let expected = [Character(id: 1, name: "IronMan", imageUrl: "url", description: "")]
        let repo = MockRepo()
        repo.stubbedCharacters = expected
        let sut = FetchCharactersUseCase(repository: repo)
        
        // When
        let result = try await sut.execute(offset: 0)
        
        // Then
        XCTAssertEqual(result, expected)
    }
    
    func test_execute_whenFetchFails_shouldThrow() async {
        // Given
        let repo = MockRepo()
        repo.shouldThrow = true
        let sut = FetchCharactersUseCase(repository: repo)
        
        // When & Then
        do {
            _ = try await sut.execute(offset: 5)
            XCTFail("Expected error but succeeded")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TestError")
            XCTAssertEqual(nsError.code, 1)
        }
    }
    
    func test_save_shouldCallRepositoryWithCharacters() async throws {
        // Given
        let characters = [Character(id: 2, name: "Cap", imageUrl: "", description: "")]
        let repo = MockRepo()
        let sut = FetchCharactersUseCase(repository: repo)
        
        // When
        try await sut.save(characters: characters)
        
        // Then
        XCTAssertEqual(repo.receivedSavedCharacters, characters)
    }
    
    func test_save_whenRepositoryThrows_shouldThrow() async {
        // Given
        let repo = MockRepo()
        repo.shouldThrow = true
        let sut = FetchCharactersUseCase(repository: repo)
        
        // When & Then
        do {
            try await sut.save(characters: [])
            XCTFail("Expected error but succeeded")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TestError")
            XCTAssertEqual(nsError.code, 2)
        }
    }
    
    func test_fetchCachedHeroes_shouldReturnCharacters() throws {
        // Given
        let expected = [Character(id: 3, name: "Hulk", imageUrl: "", description: "Smash")]
        let repo = MockRepo()
        repo.stubbedCharacters = expected
        let sut = FetchCharactersUseCase(repository: repo)
        
        // When
        let result = try sut.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(result, expected)
    }
    
    func test_fetchCachedHeroes_whenRepositoryThrows_shouldThrow() {
        // Given
        let repo = MockRepo()
        repo.shouldThrow = true
        let sut = FetchCharactersUseCase(repository: repo)
        
        // When & Then
        do {
            _ = try sut.fetchCachedHeroes()
            XCTFail("Expected error but succeeded")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TestError")
            XCTAssertEqual(nsError.code, 3)
        }
    }
}
