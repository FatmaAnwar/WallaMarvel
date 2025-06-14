//
//  CharacterCacheRepositoryTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import XCTest
import CoreData
@testable import WallaMarvel

final class CharacterCacheRepositoryTests: XCTestCase {
    
    private var repository: CharacterCacheRepository!
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = makeInMemoryContext()
        repository = CharacterCacheRepository(context: context)
    }
    
    override func tearDown() {
        repository = nil
        context = nil
        super.tearDown()
    }
    
    func test_saveCharacters_persistsDataCorrectly() async throws {
        // Given
        let characters = [
            Character(id: 1, name: "Iron Man", imageUrl: "url1", description: "desc1"),
            Character(id: 2, name: "Thor", imageUrl: "url2", description: "desc2")
        ]
        
        // When
        try await repository.save(characters: characters)
        
        // Then
        let fetched: [CDCharacter] = try context.fetch(CDCharacter.fetchRequest())
        XCTAssertEqual(fetched.count, 2)
        XCTAssertEqual(fetched.first?.name, "Iron Man")
    }
    
    func test_fetchCachedHeroes_returnsMappedCharacters() throws {
        // Given
        let cd = CDCharacter(context: context)
        cd.id = 99
        cd.name = "Hulk"
        cd.desc = "Strongest Avenger"
        cd.imageUrl = "hulk.png"
        try context.save()
        
        // When
        let results = try repository.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Hulk")
        XCTAssertEqual(results.first?.description, "Strongest Avenger")
    }
    
    func test_clearCache_deletesAllEntries() async throws {
        // Given
        let cd1 = CDCharacter(context: context)
        cd1.id = 1
        cd1.name = "A"
        
        let cd2 = CDCharacter(context: context)
        cd2.id = 2
        cd2.name = "B"
        
        try context.save()
        
        // When
        try repository.clearCache()
        
        // Then
        let remaining = try context.fetch(CDCharacter.fetchRequest())
        XCTAssertTrue(remaining.isEmpty)
    }
    
    func test_fetchCachedHeroes_returnsDefaultValuesIfNil() throws {
        // Given
        let cd = CDCharacter(context: context)
        cd.id = 5
        // Do not assign name, desc, or imageUrl (simulate nil values)
        try context.save()
        
        // When
        let results = try repository.fetchCachedHeroes()
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Unknown")
        XCTAssertEqual(results.first?.description, "")
        XCTAssertEqual(results.first?.imageUrl, "")
    }
    
    // MARK: - Helpers
    
    private func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "WallaMarvel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = XCTestExpectation(description: "Load persistent stores")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        return container.viewContext
    }
}
