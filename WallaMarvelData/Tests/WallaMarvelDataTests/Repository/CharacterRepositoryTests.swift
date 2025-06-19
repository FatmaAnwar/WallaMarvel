//
//  CharacterRepositoryTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import XCTest
import WallaMarvelDomain
import WallaMarvelCore
@testable import WallaMarvelData

@MainActor
final class CharacterRepositoryTests: XCTestCase {
    
    var mockRemote: MockMarvelRemoteDataSource!
    var mockCache: MockCharacterCacheRepository!
    var mockMapper: MockCharacterMapper!
    var sut: CharacterRepository!
    
    override func setUp() async throws {
        mockRemote = MockMarvelRemoteDataSource()
        mockCache = MockCharacterCacheRepository(scenario: .success)
        mockMapper = MockCharacterMapper()
        sut = CharacterRepository(
            remoteDataSource: mockRemote,
            cacheRepository: mockCache,
            characterMapper: mockMapper
        )
    }
    
    override func tearDown() async throws {
        sut = nil
        mockRemote = nil
        mockCache = nil
        mockMapper = nil
    }
    
    func test_fetchCharacters_whenRemoteReturnsDTOs_shouldMapAndReturnCharacters() async throws {
        // Given
        let dtos = [
            CharacterDataModel(id: 1, name: "Hulk", thumbnail: Thumbnail(path: "hulk", extension: "jpg"), description: "smash")
        ]
        let expectedCharacters = [
            Character(id: 1, name: "Hulk", imageUrl: "hulk.jpg", description: "smash")
        ]
        mockRemote.stubbedDTOs = dtos
        mockMapper.stubbedCharacters = expectedCharacters
        
        // When
        let result = try await sut.fetchCharacters(offset: 0)
        
        // Then
        XCTAssertEqual(result, expectedCharacters)
        XCTAssertEqual(mockMapper.receivedDTOs.map(\.id), dtos.map(\.id))
    }
    
    func test_fetchCharacters_whenRemoteThrows_shouldThrowError() async {
        // Given
        mockRemote.shouldThrow = true
        
        // When & Then
        do {
            _ = try await sut.fetchCharacters(offset: 10)
            XCTFail("Expected error, but succeeded")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func test_save_whenCalled_shouldPassCharactersToCacheRepository() async throws {
        // Given
        let characters = [Character(id: 2, name: "Cap", imageUrl: "url", description: "desc")]
        
        // When
        try await sut.save(characters: characters)
        
        // Then
        XCTAssertEqual(mockCache.didCallSave, true)
    }
    
    func test_save_whenCacheThrows_shouldThrowError() async {
        // Given
        mockCache = MockCharacterCacheRepository(scenario: .failSave)
        sut = CharacterRepository(
            remoteDataSource: mockRemote,
            cacheRepository: mockCache,
            characterMapper: mockMapper
        )
        let characters = [Character(id: 5, name: "Error", imageUrl: "", description: "")]
        
        // When & Then
        do {
            try await sut.save(characters: characters)
            XCTFail("Expected error, but succeeded")
        } catch {
            XCTAssertNotNil(error, "An error was expected but none was thrown.")
        }
    }
    
    func test_fetchCachedHeroes_whenCalled_shouldReturnFromCache() throws {
        // Given
        let expected = [Character(id: 3, name: "Thor", imageUrl: "", description: "God")]
        mockCache.stubbedCharacters = expected
        
        // When
        let result = try sut.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(result, expected)
    }
    
    func test_fetchCachedHeroes_whenCacheThrows_shouldThrowError() {
        // Given
        mockCache = MockCharacterCacheRepository(scenario: .failFetch)
        sut = CharacterRepository(
            remoteDataSource: mockRemote,
            cacheRepository: mockCache,
            characterMapper: mockMapper
        )
        
        // When & Then
        XCTAssertThrowsError(try sut.fetchCachedHeroes())
    }
}
