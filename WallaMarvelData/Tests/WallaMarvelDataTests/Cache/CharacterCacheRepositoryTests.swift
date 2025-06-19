//
//  CharacterCacheRepositoryTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import CoreData
import WallaMarvelDomain
@testable import WallaMarvelData

@MainActor
final class CharacterCacheRepositoryTests: XCTestCase {
    
    var repository: CharacterCacheRepository!
    var context: NSManagedObjectContext!
    
    override func setUp() async throws {
        context = makeInMemoryContext()
        repository = CharacterCacheRepository(context: context)
    }
    
    override func tearDown() async throws {
        repository = nil
        context = nil
    }
    
    private func makeInMemoryContext() -> NSManagedObjectContext {
        let modelURL = Bundle.module.url(forResource: "WallaMarvel", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "WallaMarvel", managedObjectModel: model)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let exp = expectation(description: "Load")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
        
        return container.viewContext
    }
    
    func test_save_and_fetch_shouldPersistCharactersCorrectly() async throws {
        // Given
        let characters = [Character(id: 1, name: "Iron Man", imageUrl: "img.jpg", description: "Genius")]
        
        // When
        try await repository.save(characters: characters)
        let fetched = try repository.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, 1)
        XCTAssertEqual(fetched.first?.name, "Iron Man")
    }
    
    func test_save_shouldClearPreviousCache() async throws {
        // Given
        let first = [Character(id: 1, name: "Old", imageUrl: "url", description: "desc")]
        let second = [Character(id: 2, name: "New", imageUrl: "new", description: "fresh")]
        
        try await repository.save(characters: first)
        
        // When
        try await repository.save(characters: second)
        
        // Then
        let fetched = try repository.fetchCachedHeroes()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, 2)
    }
    
    func test_fetch_whenEmpty_returnsEmptyArray() throws {
        let result = try repository.fetchCachedHeroes()
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_fetch_whenNilFields_shouldHandleGracefully() async throws {
        // Given
        let bad = CDCharacter(context: context)
        bad.id = 999
        bad.name = ""
        bad.desc = nil
        bad.imageUrl = nil
        try context.save()
        
        // When
        let result = try repository.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(result.first?.name, "Unknown")
        XCTAssertEqual(result.first?.description, "")
    }
    
    func test_save_whenRepositoryThrows_shouldThrowError() async {
        // Given
        let failingRepo = MockFailingCharacterCacheRepository(scenario: .saveError)
        let characters = [Character(id: 1, name: "Fail", imageUrl: "", description: "")]
        
        // When & Then
        do {
            try await failingRepo.save(characters: characters)
            XCTFail("Expected error to be thrown")
        } catch let nsError as NSError {
            XCTAssertEqual(nsError.domain, "CoreData")
            XCTAssertEqual(nsError.code, 999)
        }
    }
    
    func test_fetchCachedHeroes_whenRepositoryThrows_shouldThrowError() {
        // Given
        let failingRepo = MockFailingCharacterCacheRepository(scenario: .fetchError)
        
        // When & Then
        XCTAssertThrowsError(try failingRepo.fetchCachedHeroes())
    }
}
