//
//  FetchCharactersUseCaseTests.swift
//  WallaMarvelDomain
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelDomain

@MainActor
final class FetchCharactersUseCaseTests: XCTestCase {
    
    // MARK: - Fake UseCase Implementation (System Under Test)
    struct TestUseCase: FetchCharactersUseCaseProtocol {
        let repository: CharacterRepositoryProtocol
        
        func execute(offset: Int) async throws -> [Character] {
            try await repository.fetchCharacters(offset: offset)
        }
        
        func save(characters: [Character]) async throws {
            try await repository.save(characters: characters)
        }
        
        func fetchCachedHeroes() throws -> [Character] {
            try repository.fetchCachedHeroes()
        }
    }
    
    // MARK: - Properties
    private var mockRepository: MockCharacterRepository!
    private var useCase: FetchCharactersUseCaseProtocol!
    
    // MARK: - Setup / Teardown
    override func setUp() async throws {
        mockRepository = MockCharacterRepository()
        useCase = TestUseCase(repository: mockRepository)
    }
    
    override func tearDown() async throws {
        mockRepository = nil
        useCase = nil
    }
    
    // MARK: - Tests
    
    func test_execute_withValidOffset_returnsCharacters() async throws {
        // Given
        let expected = [Character(id: 1, name: "Iron Man", imageUrl: "url", description: "desc")]
        mockRepository.stubbedCharacters = expected
        
        // When
        let result = try await useCase.execute(offset: 0)
        
        // Then
        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockRepository.fetchedOffset, 0)
    }
    
    func test_execute_whenRepositoryThrows_shouldThrowError() async {
        // Given
        mockRepository.shouldThrow = true
        
        // When & Then
        do {
            _ = try await useCase.execute(offset: 10)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_execute_withEmptyResult_shouldReturnEmptyArray() async throws {
        // Given
        mockRepository.stubbedCharacters = []
        
        // When
        let result = try await useCase.execute(offset: 5)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_save_withValidCharacters_callsRepository() async throws {
        // Given
        let characters = [Character(id: 2, name: "Hulk", imageUrl: "url", description: "smash")]
        
        // When
        try await useCase.save(characters: characters)
        
        // Then
        XCTAssertEqual(mockRepository.savedCharacters, characters)
    }
    
    func test_save_whenRepositoryThrows_shouldThrowError() async {
        // Given
        mockRepository.shouldThrow = true
        let characters = [Character(id: 99, name: "Deadpool", imageUrl: "url", description: "chaotic")]
        
        // When & Then
        do {
            try await useCase.save(characters: characters)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_fetchCachedHeroes_returnsExpectedData() throws {
        // Given
        let expected = [Character(id: 3, name: "Thor", imageUrl: "url", description: "God of Thunder")]
        mockRepository.stubbedCharacters = expected
        
        // When
        let result = try useCase.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(result, expected)
    }
    
    func test_fetchCachedHeroes_whenRepositoryThrows_shouldThrowError() {
        // Given
        mockRepository.shouldThrow = true
        
        // When & Then
        XCTAssertThrowsError(try useCase.fetchCachedHeroes())
    }
    
    func test_fetchCachedHeroes_whenEmpty_shouldReturnEmptyArray() throws {
        // Given
        mockRepository.stubbedCharacters = []
        
        // When
        let result = try useCase.fetchCachedHeroes()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
}
