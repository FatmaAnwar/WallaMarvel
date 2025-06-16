//
//  CharacterCachePersistingServiceTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class CharacterCachePersistingServiceTests: XCTestCase {
    
    private var mockRepository: MockCharacterCacheRepository!
    private var service: CharacterCachePersistingService!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterCacheRepository()
        service = CharacterCachePersistingService(repository: mockRepository)
    }
    
    override func tearDown() {
        service = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_persistIfNeeded_whenCharactersExist_callsSave() {
        // Given
        mockRepository.cachedCharacters = [
            Character(id: 1, name: "Test Hero", imageUrl: "url", description: "desc")
        ]
        
        // When
        service.persistIfNeeded()
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for async save")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.mockRepository.savedCharacters.count, 1)
            XCTAssertEqual(self.mockRepository.savedCharacters.first?.name, "Test Hero")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_persistIfNeeded_whenNoCharacters_doesNotCallSave() {
        // Given
        mockRepository.cachedCharacters = []
        
        // When
        service.persistIfNeeded()
        
        // Then
        let expectation = XCTestExpectation(description: "Wait to ensure save is not called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockRepository.savedCharacters.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_persistIfNeeded_whenFetchThrows_doesNotCrashOrSave() {
        // Given
        mockRepository.shouldThrow = true
        
        // When
        service.persistIfNeeded()
        
        // Then
        let expectation = XCTestExpectation(description: "No crash or save after fetch fails")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockRepository.savedCharacters.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
