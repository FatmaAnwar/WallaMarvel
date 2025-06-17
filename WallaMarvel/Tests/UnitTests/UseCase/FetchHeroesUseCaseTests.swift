//
//  FetchHeroesUseCaseTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class FetchHeroesUseCaseTests: XCTestCase {
    
    private var mockRepository: MockMarvelRepository!
    private var useCase: FetchCharactersUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMarvelRepository()
        useCase = FetchCharactersUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_returnsHeroes() async throws {
        // Given
        let expected = [Character(id: 1, name: "Spider-Man", imageUrl: "", description: "")]
        mockRepository.heroesToReturn = expected
        
        // When
        let result = try await useCase.execute(offset: 0)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Spider-Man")
    }
    
    func testExecute_returnsEmptyArrayWhenNoHeroes() async throws {
        // Given
        mockRepository.heroesToReturn = []
        
        // When
        let result = try await useCase.execute(offset: 0)
        
        // Then
        XCTAssertEqual(result.count, 0)
    }
    
    func testExecute_throwsOnRepositoryError() async {
        // Given
        mockRepository.shouldThrow = true
        
        // When & Then
        do {
            _ = try await useCase.execute(offset: 0)
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testFetchCachedHeroes_returnsCached() throws {
        // Given
        let expected = [Character(id: 2, name: "Iron Man", imageUrl: "", description: "")]
        mockRepository.cachedHeroes = expected
        
        // When
        let result = try useCase.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Iron Man")
    }
    
    func testSave_savesToRepository() async throws {
        // Given
        let characters = [Character(id: 3, name: "Hulk", imageUrl: "", description: "")]
        
        // When
        try await useCase.save(characters: characters)
        
        // Then
        XCTAssertEqual(mockRepository.savedHeroes.count, 1)
        XCTAssertEqual(mockRepository.savedHeroes.first?.name, "Hulk")
    }
    
    func testSave_throwsErrorWhenRepositoryFails() async {
        // Given
        mockRepository.shouldThrow = true
        let characters = [Character(id: 4, name: "Black Widow", imageUrl: "", description: "")]
        
        // When & Then
        do {
            try await useCase.save(characters: characters)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testSave_overwritesPreviouslySavedCharacters() async throws {
        // Given
        let firstBatch = [Character(id: 1, name: "A", imageUrl: "", description: "")]
        let secondBatch = [Character(id: 2, name: "B", imageUrl: "", description: "")]
        
        // When
        try await useCase.save(characters: firstBatch)
        try await useCase.save(characters: secondBatch)
        
        // Then
        XCTAssertEqual(mockRepository.savedHeroes.count, 1)
        XCTAssertEqual(mockRepository.savedHeroes.first?.name, "B")
    }
}
